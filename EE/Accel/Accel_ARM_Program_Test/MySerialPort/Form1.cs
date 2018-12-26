﻿using Microsoft.Win32;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO.Ports;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace MySerialPort
{
    public partial class AccelSmart : Form
    {
        public AccelSmart()
        {
            InitializeComponent();
            System.Windows.Forms.Control.CheckForIllegalCrossThreadCalls = false;//设置该属性 为false
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            RegistryKey keyCom = Registry.LocalMachine.OpenSubKey("Hardware\\DeviceMap\\SerialComm");
            if (keyCom != null)
            {
                string[] sSubKeys = keyCom.GetValueNames();
                cmbPort.Items.Clear();
                foreach (string sName in sSubKeys)
                {
                    string sValue = (string)keyCom.GetValue(sName);
                    cmbPort.Items.Add(sValue);
                }
                if (cmbPort.Items.Count > 0)
                    cmbPort.SelectedIndex = 0;
            }

            serialPort.DataReceived += new SerialDataReceivedEventHandler(post_DataReceived);

            cbBaud.Text = "500000";
            cbDataBits.Text = "8";
            cbStop.Text = "1";
            cbParity.Text = "无";
        }
        
        bool isOpened = false;//串口状态标志
        private void OpenCOM_Click(object sender, EventArgs e)
        {
            if (!isOpened)
            {
                serialPort.PortName = cmbPort.Text;
                serialPort.BaudRate = Convert.ToInt32(cbBaud.Text);
                serialPort.DataBits = Convert.ToInt32(cbDataBits.Text);
                switch (cbStop.Text)            //停止位
                {
                    case "1":
                        serialPort.StopBits = StopBits.One;
                        break;
                    case "1.5":
                        serialPort.StopBits = StopBits.OnePointFive;
                        break;
                    case "2":
                        serialPort.StopBits = StopBits.Two;
                        break;
                    default:
                        MessageBox.Show("Error：参数不正确!", "Error");
                        break;
                }
                switch (cbParity.Text)             //校验位
                {
                    case "无":
                        serialPort.Parity = Parity.None;
                        break;
                    case "奇校验":
                        serialPort.Parity = Parity.Odd;
                        break;
                    case "偶校验":
                        serialPort.Parity = Parity.Even;
                        break;
                    default:
                        MessageBox.Show("Error：参数不正确!", "Error");
                        break;
                }


                ReceiveTbox.Text = "";       //清空文本
                try
                {
                    serialPort.Open();     //打开串口
                    isOpened = true;
                    OpenCOM.Text = "关闭串口";
                    cmbPort.Enabled = false;//关闭使能
                    cbBaud.Enabled = false;
                //    serialPort.DataReceived += new SerialDataReceivedEventHandler(post_DataReceived);//串口接收处理函数
                }
                catch
                {
                    MessageBox.Show("串口打开失败！");
                }
            }
            else
            {
                try
                {
                    serialPort.Close();     //关闭串口
                    OpenCOM.Text = "打开串口";
                    cmbPort.Enabled = true;//打开使能
                    cbBaud.Enabled = true;
                    isOpened = false;
                }
                catch
                {
                    MessageBox.Show("串口关闭失败！");
                }
            }
            
        }
        //private void post_DataReceived(object sender, SerialDataReceivedEventArgs e)
        //{
        //    string str = serialPort.ReadExisting();//字符串方式读
        ////    ReceiveTbox.Text = "";//先清除上一次的数据
        //    ReceiveTbox.Text += str;
        //}

        private void post_DataReceived(object sender, SerialDataReceivedEventArgs e)
        {
            if (isOpened)     //此处可能没有必要判断是否打开串口，但为了严谨性，我还是加上了
            {
                byte[] byteRead = new byte[serialPort.BytesToRead];    //BytesToRead:sp1接收的字符个数
                if (false)                          //'发送字符串'单选按钮
                {
                    //                   ReceiveTbox.Text += sp1.ReadLine() + "\r\n"; //注意：回车换行必须这样写，单独使用"\r"和"\n"都不会有效果
                    ReceiveTbox.Text += serialPort.ReadLine(); //注意：回车换行必须这样写，单独使用"\r"和"\n"都不会有效果
                    serialPort.DiscardInBuffer();                      //清空SerialPort控件的Buffer 
                }
                else                                            //'发送16进制按钮'
                {
                    try
                    {
                        Byte[] receivedData = new Byte[serialPort.BytesToRead];        //创建接收字节数组
                        serialPort.Read(receivedData, 0, receivedData.Length);         //读取数据
                        //string text = sp1.Read();   //Encoding.ASCII.GetString(receivedData);
                        serialPort.DiscardInBuffer();                                  //清空SerialPort控件的Buffer
                        string strRcv = null;
                        //int decNum = 0;//存储十进制
                        for (int i = 0; i < receivedData.Length; i++) //窗体显示
                        {
                            strRcv += receivedData[i].ToString("X2");  //16进制显示
                        }
                        ReceiveTbox.Text += strRcv;
                    }
                    catch
                    {
                        MessageBox.Show("串口关闭失败！");
                    }
                }
            }
            else
            {
                MessageBox.Show("请打开某个串口", "错误提示");
            }
        }


        private void button2_Click(object sender, EventArgs e)
        {
            //发送数据
            if (serialPort.IsOpen)
            {//如果串口开启
                if (SendTbox.Text.Trim() != "")//如果框内不为空则
                {
                    serialPort.Write(SendTbox.Text.Trim());//写数据
                }
                else
                {
                    MessageBox.Show("发送框没有数据");
                }
            }
            else
            {
                MessageBox.Show("串口未打开");
            }
        }

        private void cbBaud_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
