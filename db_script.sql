USE [master]
GO
/****** Object:  Database [srCreation]    Script Date: 10/19/2015 6:22:17 AM ******/
CREATE DATABASE [srCreation]
 CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'srCreation', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\srCreation.mdf' , SIZE = 143424KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
-- LOG ON 
--( NAME = N'srCreation_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\srCreation_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
--GO
ALTER DATABASE [srCreation] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [srCreation].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [srCreation] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [srCreation] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [srCreation] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [srCreation] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [srCreation] SET ARITHABORT OFF 
GO
ALTER DATABASE [srCreation] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [srCreation] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [srCreation] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [srCreation] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [srCreation] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [srCreation] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [srCreation] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [srCreation] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [srCreation] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [srCreation] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [srCreation] SET  ENABLE_BROKER 
GO
ALTER DATABASE [srCreation] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [srCreation] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [srCreation] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [srCreation] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [srCreation] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [srCreation] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [srCreation] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [srCreation] SET RECOVERY FULL 
GO
ALTER DATABASE [srCreation] SET  MULTI_USER 
GO
ALTER DATABASE [srCreation] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [srCreation] SET DB_CHAINING OFF 
GO
ALTER DATABASE [srCreation] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [srCreation] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'srCreation', N'ON'
GO
USE [srCreation]
GO
/****** Object:  StoredProcedure [dbo].[sr_AddTo_GlobalChats]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sr_AddTo_GlobalChats]
(
	@Msg varchar(max),
	@CtdBy bigint
)
as 
begin
	begin try
		begin tran
			insert into GbChat values(@msg,@CtdBy,getdate());
		commit tran
	end try
	begin catch
		if(@@TRANCOUNT > 0 and XACT_STATE() = 1)
			rollback tran;
		throw;
	end catch
end
GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_BigUrl]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sr_Fetch_BigUrl]
( 
@Nano varchar(64)
)
as
begin
	select top 1 Url from NanoUrl readuncommitted
	where Nano = @Nano;
end


GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_Categories]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sr_Fetch_Categories]
(
	@Type tinyint,
	@ParentId smallint
)
as 
begin
	if (@Type = 0 )
	begin
		-- Offer categories.	
		select Id as Id, Name as Categ, ParentId as ParentId from PhotoCateg readuncommitted where 
		ParentId = @ParentId
	end
	else if(@Type = 1)
	begin
		-- Photo categories
		select Id as Id, Name as Categ, ParentId as ParentId from OfferCateg readuncommitted where 
		ParentId = @ParentId
	end
end

GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_GAds]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sr_Fetch_GAds]
as 
begin
	select top 3 Id as Id,Code as Code from GAd readuncommitted order by newid()
end



GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_GlobalChats]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sr_Fetch_GlobalChats]
(
	@LmId bigint
)
as 
begin
	
	select top 50 g.Id as Id, p.Fname as CtdBy,g.Msg as Msg,g.CtdOn as CtdOn from gbchat g(readuncommitted)
		join People p(readuncommitted) on g.CtdBy= p.Id
	where (@LmId is null or @LmId = 0 or g.Id > @LmId)
	order by g.CtdOn asc 
end
GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_Offers]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[sr_Fetch_Offers]
(
	@LastOfferId bigint 
	-- if id is available then find offers less than that and provide else top matters
)
as
begin
	set transaction isolation level read uncommitted;
	declare @noOfOffersToShow int
	select @noOfOffersToShow = Data from Config where Name = 'NoOfOffersToShow';

	select top (@noOfOffersToShow) a.Id,a.CatId,b.Name CatName,a.Title,a.Descn,a.OffFrom offFrom,
	a.OffEnd offEnd, a.Likes, a.DisLikes, a.ModBy, a.ModOn
    from Offers a inner join OfferCateg b on a.CatId = b.Id
	where (@LastOfferId is null or @LastOfferId = 0 or a.Id < @LastOfferId)
	order by ModOn desc

end

GO
/****** Object:  StoredProcedure [dbo].[sr_Fetch_Services]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sr_Fetch_Services]
as
begin
	select Id,Name,Descn,RouteName,Img from [Services] readuncommitted
end


GO
/****** Object:  StoredProcedure [dbo].[sr_Get_NanoUrl]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[sr_Get_NanoUrl]
(
	@BigUrl varchar(max),
	@CtdBy bigint
)
as
begin
	set transaction isolation level read uncommitted;
	
	declare @nano varchar(64); 
	declare @id bigint;

	select @nano = Nano from NanoUrl readuncommitted where Url = @BigUrl;

	if (@nano is null)
	begin
		
		select @id = min(Id) from NanoUrl readuncommitted where 
		Url is null;
		
		update NanoUrl 
		set url = @BigUrl, CtdBy = @CtdBy, CtdOn = getdate()
		where Id = @id;

		select @nano = Nano from NanoUrl readuncommitted where Id = @id;	
	end

	select @nano
end


GO
/****** Object:  Table [dbo].[Badges]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Badges](
	[Id] [tinyint] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Badge] [varchar](2048) NOT NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Beats]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Beats](
	[Id] [bigint] NOT NULL,
	[Name] [varchar](256) NULL,
	[Value] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Config]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Config](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](32) NOT NULL,
	[Data] [varchar](1024) NOT NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GAd]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GAd](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](128) NOT NULL,
	[Code] [varchar](2048) NOT NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[GbChat]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GbChat](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Msg] [varchar](max) NOT NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[IpLog]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[IpLog](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OffId] [bigint] NULL,
	[IP] [varchar](32) NOT NULL,
	[loc] [varchar](64) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[NanoUrl]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[NanoUrl](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Url] [varchar](max) NULL,
	[Nano] [varchar](64) NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Nano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OfferCateg]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OfferCateg](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
	[ParentId] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OfferCmnt]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OfferCmnt](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[OffId] [bigint] NULL,
	[Comment] [varchar](max) NOT NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Offers]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Offers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CatId] [smallint] NULL,
	[Title] [varchar](1024) NOT NULL,
	[Descn] [varchar](max) NOT NULL,
	[IsApr] [bit] NOT NULL,
	[IsRng] [bit] NOT NULL,
	[OffFrom] [datetime] NULL,
	[OffEnd] [datetime] NULL,
	[Likes] [bigint] NULL,
	[DisLikes] [bigint] NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NULL,
	[ModBy] [bigint] NULL,
	[ModOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[People]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[People](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Fname] [varchar](64) NOT NULL,
	[Lname] [varchar](64) NULL,
	[Email] [varchar](256) NOT NULL,
	[Pwd] [varchar](1024) NOT NULL,
	[Age] [tinyint] NULL,
	[Img] [varbinary](8000) NULL,
	[Dob] [datetime] NULL,
	[UserType] [tinyint] NULL,
	[ModBy] [varchar](64) NULL,
	[CtdOn] [datetime] NOT NULL,
	[ModOn] [datetime] NOT NULL,
	[IsVerif] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PhotoCateg]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhotoCateg](
	[Id] [smallint] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
	[ParentId] [smallint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PhotoCmnt]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PhotoCmnt](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[PhotoId] [bigint] NULL,
	[Comment] [varchar](max) NOT NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Photos]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Photos](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[CatId] [smallint] NULL,
	[Name] [varchar](128) NOT NULL,
	[NanoImg] [varbinary](256) NOT NULL,
	[KiloImg] [varbinary](512) NOT NULL,
	[OrgImg] [varchar](1024) NOT NULL,
	[Likes] [bigint] NULL,
	[DisLikes] [bigint] NULL,
	[IsApr] [bit] NOT NULL,
	[Descn] [varchar](max) NOT NULL,
	[CtdBy] [bigint] NULL,
	[CtdOn] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Services]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Services](
	[Id] [tinyint] NOT NULL,
	[Name] [varchar](256) NOT NULL,
	[Descn] [varchar](8000) NOT NULL,
	[RouteName] [varchar](1024) NOT NULL,
	[Img] [varbinary](1) NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserType]    Script Date: 10/19/2015 6:22:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserType](
	[Id] [tinyint] NOT NULL,
	[Name] [varchar](128) NULL,
	[CtdBy] [varchar](16) NOT NULL,
	[CtdOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Badges] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[Config] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[GAd] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[GbChat] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[NanoUrl] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[OfferCateg] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[OfferCateg] ADD  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[OfferCmnt] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT ((0)) FOR [IsApr]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT ((1)) FOR [IsRng]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT ((0)) FOR [Likes]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT ((0)) FOR [DisLikes]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[Offers] ADD  DEFAULT (getdate()) FOR [ModOn]
GO
ALTER TABLE [dbo].[People] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[People] ADD  DEFAULT (getdate()) FOR [ModOn]
GO
ALTER TABLE [dbo].[People] ADD  DEFAULT ((0)) FOR [IsVerif]
GO
ALTER TABLE [dbo].[PhotoCateg] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[PhotoCateg] ADD  DEFAULT ((0)) FOR [ParentId]
GO
ALTER TABLE [dbo].[PhotoCmnt] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[Photos] ADD  DEFAULT ((0)) FOR [Likes]
GO
ALTER TABLE [dbo].[Photos] ADD  DEFAULT ((0)) FOR [DisLikes]
GO
ALTER TABLE [dbo].[Photos] ADD  DEFAULT ((0)) FOR [IsApr]
GO
ALTER TABLE [dbo].[Photos] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[Services] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[UserType] ADD  DEFAULT (getdate()) FOR [CtdOn]
GO
ALTER TABLE [dbo].[GbChat]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[IpLog]  WITH CHECK ADD FOREIGN KEY([OffId])
REFERENCES [dbo].[Offers] ([Id])
GO
ALTER TABLE [dbo].[NanoUrl]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[OfferCmnt]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[OfferCmnt]  WITH CHECK ADD FOREIGN KEY([OffId])
REFERENCES [dbo].[Offers] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([CatId])
REFERENCES [dbo].[OfferCateg] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD FOREIGN KEY([ModBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[People]  WITH CHECK ADD FOREIGN KEY([UserType])
REFERENCES [dbo].[UserType] ([Id])
GO
ALTER TABLE [dbo].[PhotoCmnt]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
ALTER TABLE [dbo].[PhotoCmnt]  WITH CHECK ADD FOREIGN KEY([PhotoId])
REFERENCES [dbo].[Photos] ([Id])
GO
ALTER TABLE [dbo].[Photos]  WITH CHECK ADD FOREIGN KEY([CatId])
REFERENCES [dbo].[PhotoCateg] ([Id])
GO
ALTER TABLE [dbo].[Photos]  WITH CHECK ADD FOREIGN KEY([CtdBy])
REFERENCES [dbo].[People] ([Id])
GO
USE [master]
GO
ALTER DATABASE [srCreation] SET  READ_WRITE 
GO
create login bananauser with password = 'Apple123'
go
use srCreation;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'bananauser')
BEGIN
    CREATE USER bananauser FOR LOGIN bananauser
    EXEC sp_addrolemember N'db_owner', N'bananauser'
END;
GO