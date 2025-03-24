package com.s3s.solutions.eone.define;

import lombok.Getter;

@Getter
public enum ERack {

	RACK1("1"),
	RACK2("2"),
	RACK3("3"),
	RACK4("4"),
	RACK5("5"),
	RACK6("6");

	private String code;

	private ERack(String code) {
		this.code = code;
	}

}
