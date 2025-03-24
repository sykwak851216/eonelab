package com.s3s.solutions.eone.define;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Getter
public enum EOrderStatus {
	READY("0"),
	ING("2"),
	COMPLETE("9"),
	//CANCEL은 현재 미정
	CANCEL("10");

	private String code;
	EOrderStatus(String code) {
		this.code = code;
	}
}
