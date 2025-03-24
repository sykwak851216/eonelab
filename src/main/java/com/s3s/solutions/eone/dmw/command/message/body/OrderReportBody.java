package com.s3s.solutions.eone.dmw.command.message.body;

import java.util.Map;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class OrderReportBody extends DefaultBodyVO{

	private Long orderNo;
	private String orderType; //1=입고, 2=출고
	private String orderProcStatus; //0=대기, 2=처리중, 9=완료
	private String doorStatus; //1= 닫힘 2=열림
	//private String orderCompleteStatus;
	private String orderProcBufferRack1;
	private String orderProcBufferX1;
    private String orderProcBufferY1;
    private String orderProcBufferQRReadStatus1;
    private String orderProcBufferQRReadInfo1;
    private String orderProcBufferRack2;
    private String orderProcBufferX2;
    private String orderProcBufferY2;
    private String orderProcBufferQRReadStatus2;
    private String orderProcBufferQRReadInfo2;
    private String orderProcBufferRack3;
    private String orderProcBufferX3;
    private String orderProcBufferY3;
    private String orderProcBufferQRReadStatus3;
    private String orderProcBufferQRReadInfo3;
    private String orderProcBufferRack4;
    private String orderProcBufferX4;
    private String orderProcBufferY4;
    private String orderProcBufferQRReadStatus4;
    private String orderProcBufferQRReadInfo4;
    private String orderProcBufferRack5;
    private String orderProcBufferX5;
    private String orderProcBufferY5;
    private String orderProcBufferQRReadStatus5;
    private String orderProcBufferQRReadInfo5;
    private String orderProcBufferRack6;
    private String orderProcBufferX6;
    private String orderProcBufferY6;
    private String orderProcBufferQRReadStatus6;
    private String orderProcBufferQRReadInfo6;
    private String orderProcBufferRack7;
    private String orderProcBufferX7;
    private String orderProcBufferY7;
    private String orderProcBufferQRReadStatus7;
    private String orderProcBufferQRReadInfo7;
    private String orderProcBufferRack8;
    private String orderProcBufferX8;
    private String orderProcBufferY8;
    private String orderProcBufferQRReadStatus8;
    private String orderProcBufferQRReadInfo8;
    private String orderProcBufferRack9;
    private String orderProcBufferX9;
    private String orderProcBufferY9;
    private String orderProcBufferQRReadStatus9;
    private String orderProcBufferQRReadInfo9;
    private String orderProcBufferRack10;
    private String orderProcBufferX10;
    private String orderProcBufferY10;
    private String orderProcBufferQRReadStatus10;
    private String orderProcBufferQRReadInfo10;
    private String orderProcBufferRack11;
    private String orderProcBufferX11;
    private String orderProcBufferY11;
    private String orderProcBufferQRReadStatus11;
    private String orderProcBufferQRReadInfo11;
    
    private String orderProcBufferRack12;
    private String orderProcBufferX12;
    private String orderProcBufferY12;
    private String orderProcBufferQRReadStatus12;
    private String orderProcBufferQRReadInfo12;
    //private String trayProcStatus;
    private Map<String, Object> orderTrayProcStatus;
}

