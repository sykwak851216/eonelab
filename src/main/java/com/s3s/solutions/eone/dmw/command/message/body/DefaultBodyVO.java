package com.s3s.solutions.eone.dmw.command.message.body;

import com.s3s.sfp.service.common.CommonDTO;

public class DefaultBodyVO extends CommonDTO {

	private long receviveTimeMs;

	public long getReceviveTimeMs() {
		return receviveTimeMs;
	}

	public void setReceviveTimeMs(long receviveTimeMs) {
		this.receviveTimeMs = receviveTimeMs;
	}

}
