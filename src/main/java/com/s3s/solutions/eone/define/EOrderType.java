package com.s3s.solutions.eone.define;

import lombok.Getter;

public enum EOrderType {
	INPUT("보관업무", "1"), OUTPUT("폐기업무", "2"), INQUIRY("호출업무", "0");

	@Getter
	private String text;
	@Getter
	private String code;

	private EOrderType(String text, String code) {
		this.text = text;
		this.code = code;
	}
}
