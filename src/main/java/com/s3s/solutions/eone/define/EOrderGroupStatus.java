package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum EOrderGroupStatus {
	READY("준비"),
	ING("진행중"),
	COMPLETE("완료"),
	CANCEL("취소");

	private String text;

	private EOrderGroupStatus(String text) {
		this.text = text;
	}
}
