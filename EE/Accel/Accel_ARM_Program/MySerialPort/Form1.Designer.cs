namespace MySerialPort
{
    partial class AccelSmart
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要修改
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AccelSmart));
            this.serialPort = new System.IO.Ports.SerialPort(this.components);
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.OpenCOM = new System.Windows.Forms.Button();
            this.cbParity = new System.Windows.Forms.ComboBox();
            this.cbDataBits = new System.Windows.Forms.ComboBox();
            this.cbStop = new System.Windows.Forms.ComboBox();
            this.cbBaud = new System.Windows.Forms.ComboBox();
            this.label5 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.cbPort = new System.Windows.Forms.ComboBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.ReceiveTbox = new System.Windows.Forms.TextBox();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.SendTbox = new System.Windows.Forms.TextBox();
            this.button2 = new System.Windows.Forms.Button();
            this.SaveData = new System.Windows.Forms.Button();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.SuspendLayout();
            // 
            // serialPort
            // 
            this.serialPort.ReceivedBytesThreshold = 10;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.OpenCOM);
            this.groupBox1.Controls.Add(this.cbParity);
            this.groupBox1.Controls.Add(this.cbDataBits);
            this.groupBox1.Controls.Add(this.cbStop);
            this.groupBox1.Controls.Add(this.cbBaud);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.cbPort);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(3, 10);
            this.groupBox1.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox1.Size = new System.Drawing.Size(296, 125);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "串口设置";
            // 
            // OpenCOM
            // 
            this.OpenCOM.Location = new System.Drawing.Point(152, 18);
            this.OpenCOM.Margin = new System.Windows.Forms.Padding(4);
            this.OpenCOM.Name = "OpenCOM";
            this.OpenCOM.Size = new System.Drawing.Size(100, 29);
            this.OpenCOM.TabIndex = 4;
            this.OpenCOM.Text = "打开串口";
            this.OpenCOM.UseVisualStyleBackColor = true;
            this.OpenCOM.Click += new System.EventHandler(this.OpenCOM_Click);
            // 
            // cbParity
            // 
            this.cbParity.FormattingEnabled = true;
            this.cbParity.Items.AddRange(new object[] {
            "无",
            "奇校验",
            "偶校验"});
            this.cbParity.Location = new System.Drawing.Point(211, 93);
            this.cbParity.Margin = new System.Windows.Forms.Padding(4);
            this.cbParity.Name = "cbParity";
            this.cbParity.Size = new System.Drawing.Size(77, 23);
            this.cbParity.TabIndex = 3;
            this.cbParity.SelectedIndexChanged += new System.EventHandler(this.cbBaud_SelectedIndexChanged);
            // 
            // cbDataBits
            // 
            this.cbDataBits.FormattingEnabled = true;
            this.cbDataBits.Items.AddRange(new object[] {
            "5",
            "6",
            "7",
            "8"});
            this.cbDataBits.Location = new System.Drawing.Point(211, 57);
            this.cbDataBits.Margin = new System.Windows.Forms.Padding(4);
            this.cbDataBits.Name = "cbDataBits";
            this.cbDataBits.Size = new System.Drawing.Size(77, 23);
            this.cbDataBits.TabIndex = 3;
            this.cbDataBits.SelectedIndexChanged += new System.EventHandler(this.cbBaud_SelectedIndexChanged);
            // 
            // cbStop
            // 
            this.cbStop.FormattingEnabled = true;
            this.cbStop.Items.AddRange(new object[] {
            "1",
            "1.5",
            "2"});
            this.cbStop.Location = new System.Drawing.Point(63, 93);
            this.cbStop.Margin = new System.Windows.Forms.Padding(4);
            this.cbStop.Name = "cbStop";
            this.cbStop.Size = new System.Drawing.Size(77, 23);
            this.cbStop.TabIndex = 3;
            this.cbStop.SelectedIndexChanged += new System.EventHandler(this.cbBaud_SelectedIndexChanged);
            // 
            // cbBaud
            // 
            this.cbBaud.FormattingEnabled = true;
            this.cbBaud.Items.AddRange(new object[] {
            "4800",
            "9600",
            "19200",
            "38400",
            "115200",
            "500000"});
            this.cbBaud.Location = new System.Drawing.Point(63, 57);
            this.cbBaud.Margin = new System.Windows.Forms.Padding(4);
            this.cbBaud.Name = "cbBaud";
            this.cbBaud.Size = new System.Drawing.Size(77, 23);
            this.cbBaud.TabIndex = 3;
            this.cbBaud.SelectedIndexChanged += new System.EventHandler(this.cbBaud_SelectedIndexChanged);
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(152, 97);
            this.label5.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(67, 15);
            this.label5.TabIndex = 1;
            this.label5.Text = "校验位：";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(152, 61);
            this.label3.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(67, 15);
            this.label3.TabIndex = 1;
            this.label3.Text = "数据位：";
            // 
            // cbPort
            // 
            this.cbPort.FormattingEnabled = true;
            this.cbPort.Location = new System.Drawing.Point(63, 21);
            this.cbPort.Margin = new System.Windows.Forms.Padding(4);
            this.cbPort.Name = "cbPort";
            this.cbPort.Size = new System.Drawing.Size(77, 23);
            this.cbPort.TabIndex = 2;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(4, 97);
            this.label4.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(67, 15);
            this.label4.TabIndex = 1;
            this.label4.Text = "停止位：";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(4, 61);
            this.label2.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(67, 15);
            this.label2.TabIndex = 1;
            this.label2.Text = "波特率：";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(11, 25);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(60, 15);
            this.label1.TabIndex = 0;
            this.label1.Text = "串 口：";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.SaveData);
            this.groupBox2.Controls.Add(this.ReceiveTbox);
            this.groupBox2.Location = new System.Drawing.Point(307, 10);
            this.groupBox2.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox2.Size = new System.Drawing.Size(415, 552);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "接收数据";
            // 
            // ReceiveTbox
            // 
            this.ReceiveTbox.Location = new System.Drawing.Point(12, 26);
            this.ReceiveTbox.Margin = new System.Windows.Forms.Padding(4);
            this.ReceiveTbox.Multiline = true;
            this.ReceiveTbox.Name = "ReceiveTbox";
            this.ReceiveTbox.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.ReceiveTbox.Size = new System.Drawing.Size(381, 466);
            this.ReceiveTbox.TabIndex = 0;
            this.ReceiveTbox.TabStop = false;
            this.ReceiveTbox.TextChanged += new System.EventHandler(this.ReceiveTbox_TextChanged);
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.SendTbox);
            this.groupBox3.Controls.Add(this.button2);
            this.groupBox3.Location = new System.Drawing.Point(3, 143);
            this.groupBox3.Margin = new System.Windows.Forms.Padding(4);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Padding = new System.Windows.Forms.Padding(4);
            this.groupBox3.Size = new System.Drawing.Size(296, 96);
            this.groupBox3.TabIndex = 2;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "发送数据";
            // 
            // SendTbox
            // 
            this.SendTbox.Location = new System.Drawing.Point(8, 25);
            this.SendTbox.Margin = new System.Windows.Forms.Padding(4);
            this.SendTbox.Multiline = true;
            this.SendTbox.Name = "SendTbox";
            this.SendTbox.ScrollBars = System.Windows.Forms.ScrollBars.Horizontal;
            this.SendTbox.Size = new System.Drawing.Size(261, 28);
            this.SendTbox.TabIndex = 1;
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(8, 61);
            this.button2.Margin = new System.Windows.Forms.Padding(4);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(100, 29);
            this.button2.TabIndex = 5;
            this.button2.Text = "发送";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // SaveData
            // 
            this.SaveData.Location = new System.Drawing.Point(54, 500);
            this.SaveData.Margin = new System.Windows.Forms.Padding(4);
            this.SaveData.Name = "SaveData";
            this.SaveData.Size = new System.Drawing.Size(100, 29);
            this.SaveData.TabIndex = 4;
            this.SaveData.Text = "保存数据";
            this.SaveData.UseVisualStyleBackColor = true;
            this.SaveData.Click += new System.EventHandler(this.SaveData_Click);
            // 
            // AccelSmart
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 15F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(734, 575);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4);
            this.Name = "AccelSmart";
            this.Text = "AccelSmart";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.IO.Ports.SerialPort serialPort;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.Button OpenCOM;
        private System.Windows.Forms.ComboBox cbBaud;
        private System.Windows.Forms.ComboBox cbPort;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.TextBox SendTbox;
        private System.Windows.Forms.TextBox ReceiveTbox;
        private System.Windows.Forms.ComboBox cbDataBits;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.ComboBox cbParity;
        private System.Windows.Forms.ComboBox cbStop;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Button SaveData;
    }
}

