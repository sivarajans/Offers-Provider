using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.SqlClient;
using srShared;
using System.Data;
namespace srCnn
{
    public class Connector : IDisposable
    {
        private SqlConnection oSqlConn;
        private SqlTransaction oSqlTran;
        private SqlCommand oSqlCommand = null;
        private bool bSelfOpened = false;
        /// <summary>
        /// Creates sql connection and opens it.
        /// </summary>
        public void CreateSqlConn()
        {
            oSqlConn = new SqlConnection(SharedAcross.Local.SqlConString);
            oSqlConn.Open();
        }
        /// <summary>
        /// Closes and disposes connection if opened
        /// </summary>
        public void DestroySqlConn()
        {
            if (oSqlConn != null)
            {
                if (oSqlConn.State == System.Data.ConnectionState.Open)
                    oSqlConn.Close();
                oSqlConn.Dispose();
            }
        }
        /// <summary>
        /// Creates transaction
        /// </summary>
        public void CreateSqlTran()
        {
            oSqlTran = oSqlConn.BeginTransaction();
        }
        /// <summary>
        /// Commits and dispose transaction
        /// </summary>
        public void CommitSqlTran()
        {
            oSqlTran.Commit();
            oSqlTran.Dispose();
        }
        /// <summary>
        /// Rollbacks and dispose trasanction
        /// </summary>
        public void RollbackSqlTran()
        {
            oSqlTran.Rollback();
            oSqlTran.Dispose();
        }
        /// <summary>
        /// Destroys SqlConnecion
        /// </summary>
        public void Dispose()
        {
            if (oSqlTran != null) oSqlTran.Dispose();
            DestroySqlConn();
        }
        /// <summary>
        /// Returns true if connection is opened already
        /// </summary>
        /// <returns>Return true if connection opened</returns>
        private bool IsCnnOpen()
        {
            if (oSqlConn != null && oSqlConn.State == ConnectionState.Open)
                return true;
            else
                return false;
        }
        /// <summary>
        /// Get connection prerequisites
        /// </summary>
        /// <param name="sqlParCol">sqlParam</param>
        /// <param name="commandName">Proc or inline command</param>
        private void GetCnnNeed(List<SqlParameter> sqlParCol, string commandName, CommandType cmdType)
        {
            if (IsCnnOpen())
                bSelfOpened = false;
            else
            {
                CreateSqlConn();
                bSelfOpened = true;
            }
            oSqlCommand = new SqlCommand(commandName, oSqlConn);
            oSqlCommand.CommandType = cmdType;
            oSqlCommand.Parameters.AddRange(sqlParCol.ToArray());
        }
        /// <summary>
        /// Executes and returns dataset
        /// </summary>
        /// <param name="sqlParCol"></param>
        /// <param name="commandName"></param>
        /// <returns></returns>
        public DataSet ExecDataSet(List<SqlParameter> sqlParCol, string commandName, CommandType cmdType = CommandType.StoredProcedure)
        {
            DataSet result = new DataSet();
            SqlDataAdapter dataAdp = null;
            try
            {
                GetCnnNeed(sqlParCol, commandName, cmdType);
                dataAdp = new SqlDataAdapter(oSqlCommand);
                dataAdp.Fill(result);
            }
            catch
            {
                throw;
            }
            finally
            {
                if (bSelfOpened)
                    DestroySqlConn();
                if (oSqlCommand != null) oSqlCommand.Dispose();
            }
            return result;
        }
        /// <summary>
        /// Only to execute and returns affected
        /// </summary>
        /// <param name="sqlParCol"></param>
        /// <param name="commandName"></param>
        /// <returns></returns>
        public int Exec(List<SqlParameter> sqlParCol, string commandName, CommandType cmdType = CommandType.StoredProcedure)
        {
            int result;
            try
            {
                GetCnnNeed(sqlParCol, commandName, cmdType);
                result = oSqlCommand.ExecuteNonQuery();
            }
            catch
            {
                throw;
            }
            finally
            {
                if (bSelfOpened)
                    DestroySqlConn();
                if (oSqlCommand != null) oSqlCommand.Dispose();
            }
            return result;
        }
        /// <summary>
        /// Returns scalar.
        /// </summary>
        /// <param name="sqlParCol"></param>
        /// <param name="commandName"></param>
        /// <returns></returns>
        public string ExecScalar(List<SqlParameter> sqlParCol, string commandName, CommandType cmdType = CommandType.StoredProcedure)
        {
            string result;
            try
            {
                GetCnnNeed(sqlParCol, commandName, cmdType);
                result = Convert.ToString(oSqlCommand.ExecuteScalar());
            }
            catch
            {
                throw;
            }
            finally
            {
                if (bSelfOpened)
                    DestroySqlConn();
                if (oSqlCommand != null) oSqlCommand.Dispose(); 
            }
            return result;
        }
    }
}
