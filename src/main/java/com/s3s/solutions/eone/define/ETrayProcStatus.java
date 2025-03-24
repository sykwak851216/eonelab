package com.s3s.solutions.eone.define;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum ETrayProcStatus {
	READY("0"),
	//ING("1"),
	EXCEPTION("2"),
	COMPLETE("1");

	private String code;
	ETrayProcStatus(String code) {
		this.code = code;
	}
}
