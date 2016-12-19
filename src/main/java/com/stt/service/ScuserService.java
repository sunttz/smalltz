package com.stt.service;

import com.github.pagehelper.PageInfo;
import com.stt.entity.Scuser;

public interface ScuserService {

	public Scuser findById(int id);
	
	PageInfo<Scuser> queryByPage(String name,Integer pageNo,Integer pageSize);
}
