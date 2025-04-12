package com.s3s.solutions.eone.dmw.command.message.body;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class InHounseTrayBody extends DefaultBodyVO{
	private String trayId; //Scan한 TrayId
}