package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum EOrderGroupFinishStatus {
	SUCCESS("정상"), FAIL("실패");

	private String text;

	private EOrderGroupFinishStatus(String text) {
		this.text = text;
	}
}
