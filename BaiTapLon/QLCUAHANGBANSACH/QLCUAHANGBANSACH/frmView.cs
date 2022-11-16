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
    public partial class frmView : Form
    {
        public frmView()
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
            lbCauHoi.Text = "Câu 1: Tạo view liệt kê sách được bán nhiều nhất trong tháng 10, năm 2022";
            dgvResult.DataSource = connection.DataReader("select * from cau1n3");
        }

        private void guna2GradientButton2_Click(object sender, EventArgs e)
        {
            lbCauHoi.Text = "Câu 2: Tạo view danh sách nhân viên xuất sắc nhất trong tháng 5/2022,có tổng các hóa đơn bán và nhập cao nhất.";
            dgvResult.DataSource = connection.DataReader("select * from cau2n3");
        }

        private void guna2GradientButton3_Click(object sender, EventArgs e)
        {
            lbCauHoi.Text = "Câu 3: Tạo view danh sách top 10 khách hàng có tổng tiền các hóa đơn nhiều cao nhất trong năm 2022.";
            dgvResult.DataSource = connection.DataReader("select * from cau3n3");
        }

        private void guna2GradientButton4_Click(object sender, EventArgs e)
        {
            lbCauHoi.Text = "Câu 4: Tạo view liệt kê các sách có giá bán từ 50.000-> 100.000đ";
            dgvResult.DataSource = connection.DataReader("select * from cau4n3");
        }

        private void guna2GradientButton5_Click(object sender, EventArgs e)
        {
            lbCauHoi.Text = "Câu 5: Tạo view liệt kê các sách không bán được trong tháng 10/2022";
            dgvResult.DataSource = connection.DataReader("select * from cau5n3");
        }
    }
}
