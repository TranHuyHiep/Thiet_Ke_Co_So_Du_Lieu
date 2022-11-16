using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QLCUAHANGBANSACH.Database
{
    internal class Connection
    {
        string strConnect = "Data Source=MYPC;Initial Catalog=BTL_NHOM3_QLBanSach;Integrated Security=True";
        SqlConnection sqlConnection = null;

        void OpenConnect()
        {
            sqlConnection = new SqlConnection(strConnect);
            if (sqlConnection.State != ConnectionState.Open)
            {
                sqlConnection.Open();
            }
        }

        void CloseConnect()
        {
            if (sqlConnection.State != ConnectionState.Closed)
            {
                sqlConnection.Close();
                sqlConnection.Dispose();
            }
        }

        public DataTable DataReader(string sqlSelect)
        {
            DataTable dataTable = new DataTable();
            OpenConnect();
            SqlDataAdapter sqlData = new SqlDataAdapter(sqlSelect, sqlConnection);
            sqlData.Fill(dataTable);
            CloseConnect();
            return dataTable;
        }

        public void DataChange(string sql)
        {
            OpenConnect();
            SqlCommand sqlCommand = new SqlCommand();
            sqlCommand.Connection = sqlConnection;
            sqlCommand.CommandText = sql;
            sqlCommand.ExecuteNonQuery();
            CloseConnect();
        }
    }
}
