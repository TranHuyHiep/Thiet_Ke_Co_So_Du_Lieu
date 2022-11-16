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
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void panel1_Paint(object sender, PaintEventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        bool CheckExistForm(string formName)
        {
            bool check = false;
            foreach (Form frm in this.MdiChildren)
            {
                if (frm.Name == formName)
                {
                    check = true;
                    break;
                }
            }
            return check;
        }
        bool ActiveChildForm(string formName)
        {
            bool check = false;
            foreach (Form frm in this.MdiChildren)
            {
                if (frm.Name == formName)
                {
                    frm.Activate();
                    break;
                }
            }
            return check;
        }

        private void guna2GradientButton3_Click(object sender, EventArgs e)
        {
            if (!CheckExistForm("frmView"))
            {
                frmView fView = new frmView();
                fView.MdiParent = this;
                fView.Dock = DockStyle.Fill;
                fView.Show();
            }
            else
            {
                ActiveChildForm("frmView");
            }

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            FormBorderStyle = FormBorderStyle.None;
            WindowState = FormWindowState.Maximized;
        }

        private void guna2GradientButton1_Click(object sender, EventArgs e)
        {
            if (!CheckExistForm("frmFunction"))
            {
                frmFunction fFunction = new frmFunction();
                fFunction.MdiParent = this;
                fFunction.Dock = DockStyle.Fill;
                fFunction.Show();
            }
            else
            {
                ActiveChildForm("frmFunction");
            }
        }

        private void guna2GradientButton2_Click(object sender, EventArgs e)
        {
            if (!CheckExistForm("frmProcedure"))
            {
                frmProcedure fProcedure = new frmProcedure();
                fProcedure.MdiParent = this;
                fProcedure.Dock = DockStyle.Fill;
                fProcedure.Show();
            }
            else
            {
                ActiveChildForm("frmProcedure");
            }
        }
    }
}
