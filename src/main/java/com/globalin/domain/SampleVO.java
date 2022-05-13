package com.globalin.domain;

public class SampleVO {

	private Integer mno;
	private String firstName;
	private String lastName;
	
	public SampleVO() {
		
	}
	public Integer getMno() {
		return mno;
	
		
	}
	public SampleVO(Integer mno, String firstName, String lastName) {
		super();
		this.mno = mno;
		this.firstName = firstName;
		this.lastName = lastName;
	}
	public void setMno(Integer mno) {
		this.mno = mno;
	}
	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}
	@Override
	public String toString() {
		return "SampleVO [mno=" + mno + ", firstName=" + firstName + ", lastName=" + lastName + "]";
	}
	
}
