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
    public partial class frmFunction : Form
    {
        public frmFunction()
        {
            InitializeComponent();
        }

        Connection connection = new Connection();

        private void guna2GradientButton6_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void guna2GradientButton1_Click(object sender, EventArgs e)
        {
            lbFunCauHoi.Text = "Câu1 : Tạo hàm đưa ra tổng số tiền đã nhập sách trong một năm với tham số đầu vào là năm";
            dgvFunResult.DataSource = connection.DataReader("select * from dbo.tien(2022)");
        }

        private void guna2GradientButton2_Click(object sender, EventArgs e)
        {
            lbFunCauHoi.Text = "Câu2 : Tạo hàm đưa ra danh sách 5 đầu sách bán chạy nhất trong tháng nào đó (tháng là tham số đầu vào)";
            dgvFunResult.DataSource = connection.DataReader("select * from dbo.top5(2022,10)");
        }

        private void guna2GradientButton3_Click(object sender, EventArgs e)
        {
            lbFunCauHoi.Text = "Câu3 : Tạo hàm đưa ra danh sách n nhân viên có doanh thu cao nhất trong một năm với n và năm là tham số đầu vào";
            dgvFunResult.DataSource = connection.DataReader("Select * from topNV(10, 2022)");
        }

        private void guna2GradientButton4_Click(object sender, EventArgs e)
        {
            lbFunCauHoi.Text = "Câu4 : Tạo hàm đưa ra thông tin Nhân viên sinh nhật trong ngày sinh là tham số nhập vào";
            dgvFunResult.DataSource = connection.DataReader("select * from SN('2002-01-02')");
        }

        private void guna2GradientButton5_Click(object sender, EventArgs e)
        {
            lbFunCauHoi.Text = "Câu5 : Tạo hàm với đầu vào là ngày, đầu ra là thông tin các hóa đơn và trị giá của hóa đơn trong ngày đó";
            dgvFunResult.DataSource = connection.DataReader("select * from TTHD(30, 10, 2022)");
        }
    }
}
