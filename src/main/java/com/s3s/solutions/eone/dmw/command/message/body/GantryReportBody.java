package com.s3s.solutions.eone.dmw.command.message.body;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class GantryReportBody extends DefaultBodyVO{
	/*
	private String plcMode;// 1: 지시 호출 가능
	private String gantryStatus1;// 1: 정상, 2: 알람
	private String gantryOperationMode1;// 0: 대기, 1: 입고, 2: 출고
	private String gantryStatus2;// 1: 정상, 2: 알람
	private String gantryOperationMode2;// 0: 대기, 1: 입고, 2: 출고
	private String gantryStatus3;// 1: 정상, 2: 알람
	private String gantryOperationMode3;// 0: 대기, 1: 입고, 2: 출고
	*/
	
	private String gantryStatus;// 1: 정상, 2: 알람
	private String gantryOperationMode;// 0: 대기, 1: 입고, 2: 출고
	private String gantryDataRcvStatus;// 0: 불가, 1: 가능
	
}
