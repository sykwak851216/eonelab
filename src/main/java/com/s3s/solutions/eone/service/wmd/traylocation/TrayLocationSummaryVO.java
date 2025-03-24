package com.s3s.solutions.eone.service.wmd.traylocation;

import java.util.ArrayList;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrayLocationSummaryVO{

	private String mcId;
	private String lineNo;

	private List<TrayLocationVO> trayLocationList = new ArrayList<>();

	public int getTrayLocationListSize() {
		return trayLocationList.size();
	}
}