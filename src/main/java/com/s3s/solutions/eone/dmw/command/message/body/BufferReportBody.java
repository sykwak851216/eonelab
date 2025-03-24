package com.s3s.solutions.eone.dmw.command.message.body;

import java.util.Map;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@RequiredArgsConstructor
public class BufferReportBody extends DefaultBodyVO{
	
	private String bufferNo;
	private String bufferStatus; //1=정상, 2=알람
	private String bufferOperationMode; //0=대기, 1=이동중, 2=이동완료
	private String bufferPreLocation;
    private String bufferTargetLocation;
    private String bufferCellSensingResult;
    private Map<String, String> bufferCellStatus;

}