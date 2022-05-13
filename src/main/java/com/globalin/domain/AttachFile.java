package com.globalin.domain;

public class AttachFile {

	private String filename;
	private boolean image;
	private String uploadpath;
	private String uuid;
	
	public String getFilename() {
		return filename;
	}



	public boolean isImage() {
		return image;
	}



	public void setImage(boolean image) {
		this.image = image;
	}



	public void setFilename(String filename) {
		this.filename = filename;
	}

	

	public String getUploadpath() {
		return uploadpath;
	}

	public void setUploadpath(String uploadpath) {
		this.uploadpath = uploadpath;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	@Override
	public String toString() {
		return "AttachFile [filename=" + filename + ", image=" + image + ", uploadpath=" + uploadpath + ", uuid=" + uuid
				+ "]";
	}

	

}
