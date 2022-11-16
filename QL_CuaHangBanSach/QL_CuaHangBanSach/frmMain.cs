using QL_CuaHangBanSach.Classes;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace QL_CuaHangBanSach
{
    public partial class frmMain : Form
    {
        public frmMain()
        {
            InitializeComponent();
        }

        ConnectData connectData = new ConnectData();

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void guna2GradientButton1_Click(object sender, EventArgs e)
        {
            lbDeBai.Text = "Tạo hàm đưa ra tổng số tiền đã nhập sách trong một năm với tham số đầu vào là năm";
            dgvResult.DataSource = connectData.ReadData("select dbo.Function_cau1(2022) as TongTien");
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }

        private void guna2GradientButton4_Click(object sender, EventArgs e)
        {
            lbDeBai.Text = "Tạo view liệt kê sách được bán nhiều nhất trong tháng 4, năm 2022";
            dgvResult.DataSource = connectData.ReadData("select * from View_cau1");
        }
    }
}
