using QLCUAHANGBANSACH.Database;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QLCUAHANGBANSACH
{
    public partial class frmProcedure : Form
    {
        public frmProcedure()
        {
            InitializeComponent();
        }

        Connection connection = new Connection();

        private void guna2GradientButton6_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void guna2GradientButton4_Click(object sender, EventArgs e)
        {
           // lbProCauHoi.Text = "Câu 4: Tạo hàm thủ tục có đầu vào Tên tác giả , năm đầu ra số lượng sách của tác giả đã bán được trong năm đó";
           // DataTable dataTable = connection.DataReader("declare @solg int \r\n exec cau4_p N'Nguyễn Ngọc Tư',2022, @solg output \r\n select @solg as test");

           // string resuslt = dataTable.Rows[0]["test"].ToString();
           // lbProResult.Text = "Số lượng sách của tác giả Nguyễn Ngọc Tư bán được trong năm 2022 là: " +  resuslt;
        }

        private void guna2GradientButton1_Click(object sender, EventArgs e)
        {
           // lbProCauHoi.Text = "Câu 1: Tạo hàm thủ tục có đầu vào là số mã sach đầu ra là số lượng hóa đơn bán sách đó";
           // DataTable dataTable = connection.DataReader("declare @solg int\r\nexec cau1_p N'S01', @solg output\r\n select @solg as test");

           // string resuslt = dataTable.Rows[0]["test"].ToString();
           // lbProResult.Text = "Số lượng hóa đơn của sách S01 là: " + resuslt;
        }

        private void guna2GradientButton3_Click(object sender, EventArgs e)
        {
            //lbProCauHoi.Text = "Câu 3: Tạo hàm thủ tục có đầu vào là tháng, năm đầu ra là số lượng hóa đơn và tổng tiền trong tháng năm đó";
            //DataTable dataTable = connection.DataReader("declare @tongtien money, @sohd int\r\nexec cau3_p 10,2022, @sohd output,@tongtien output\r\nselect @sohd as SoHD, @tongtien as TongTien");

            //string resuslt1 = dataTable.Rows[0]["SoHD"].ToString();
           // string resuslt2 = dataTable.Rows[0]["TongTien"].ToString();

           // lbProResult.Text = "Số lượng hóa đơn của tháng 10 năm 2022 là: " + resuslt1 + "\n" +
           //                    "Tổng tiền hóa đơn của tháng 10 năm 2022 là: " + resuslt2;
        }

        private void guna2GradientButton5_Click(object sender, EventArgs e)
        {
           // lbProCauHoi.Text = "Câu 5: Tạo hàm thủ tục có đầu vào là thể loại đầu ra là số lượng sách có thể loại đó.";
           // DataTable dataTable = connection.DataReader("declare @solg int\r\nexec cau5_p N'Tiểu thuyết', @solg output\r\nselect @solg as test");

           // string resuslt = dataTable.Rows[0]["test"].ToString();
           // lbProResult.Text = "Số lượng sách của thể loại Tiểu thuyết là: " + resuslt;
        }

        private void guna2GradientButton2_Click(object sender, EventArgs e)
        {
           // lbProCauHoi.Text = "Câu 2: Tạo hàm thủ tục có đầu vào là tên nhân viên đầu ra tổng tiền và số hóa đơn bán của nhân vien này.";
            //DataTable dataTable = connection.DataReader("declare @tongsotien money, @tongsohd int\r\nexec cau2_p N'NV01', @tongsotien output, @tongsohd output\r\nselect @tongsotien, @tongsohd");

           // string resuslt1 = dataTable.Rows[0][0].ToString();
           // string resuslt2 = dataTable.Rows[0][1].ToString();
           // lbProResult.Text = "Tổng số hóa đơn của nhân viên NV01 là: " + resuslt2 + "\n" +
           //                     "Tổng tiền bán của nhân viên NV01 là: " + resuslt1;
        }

        private void guna2GradientButton21_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void guna2GradientButton10_Click(object sender, EventArgs e)
        {
            DataTable dataTable = connection.DataReader("declare @solg int\r\nexec cau1_p N'" + txtCau1.Text + "', @solg output\r\n select @solg as test");

            string resuslt = dataTable.Rows[0]["test"].ToString();
            lbResult1.Text = "Số lượng hóa đơn của sách " + txtCau1.Text + " là: " + resuslt;
        }

        private void guna2GradientButton9_Click(object sender, EventArgs e)
        {
            DataTable dataTable = connection.DataReader("declare @tongsotien money, @tongsohd int\r\nexec cau2_p N'" + txtCau2.Text + "', @tongsotien output, @tongsohd output\r\nselect @tongsotien, @tongsohd");

            string resuslt1 = dataTable.Rows[0][0].ToString();
            string resuslt2 = dataTable.Rows[0][1].ToString();
            lbResult2.Text = "Tổng số hóa đơn của nhân viên " + txtCau2.Text + " là: " + resuslt2 + "\n" +
                                "Tổng tiền bán của nhân viên " + txtCau2.Text + " là: " + resuslt1;
        }

        private void guna2GradientButton12_Click(object sender, EventArgs e)
        {
            DataTable dataTable = connection.DataReader("declare @tongtien money, @sohd int\r\nexec cau3_p " + txtCau3_1.Text + "," + txtCau3_2.Text + ", @sohd output,@tongtien output\r\nselect @sohd as SoHD, @tongtien as TongTien");

            string resuslt1 = dataTable.Rows[0]["SoHD"].ToString();
            string resuslt2 = dataTable.Rows[0]["TongTien"].ToString();

            lbResult3.Text = "Số lượng hóa đơn của tháng " + txtCau3_1.Text + " năm " + txtCau3_2.Text + " là: " + resuslt1 + "\n" +
                               "Tổng tiền hóa đơn của tháng " + txtCau3_1.Text + " năm " + txtCau3_2.Text + " là: " + resuslt2;
        }

        private void guna2GradientButton8_Click(object sender, EventArgs e)
        {
            DataTable dataTable = connection.DataReader("declare @solg int\r\nexec cau5_p N'" + txtCau5.Text + "', @solg output\r\nselect @solg as test");

            string resuslt = dataTable.Rows[0]["test"].ToString();
            lbResult5.Text = "Số lượng sách của thể loại " + txtCau5.Text + " là: " + resuslt;
        }

        private void guna2GradientButton11_Click(object sender, EventArgs e)
        {
            DataTable dataTable = connection.DataReader("declare @solg int \r\n exec cau4_p N'" + txtCau4_1.Text + "'," + txtCau4_2.Text + ", @solg output \r\n select @solg as test");

            string resuslt = dataTable.Rows[0]["test"].ToString();
            lbResult4.Text = "Số lượng sách của tác giả " + txtCau4_1.Text + " bán được trong năm " + txtCau4_2.Text + " là: " + resuslt;
        }
    }
}
