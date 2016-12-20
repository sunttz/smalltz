package com.stt.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.stt.dao.ScuserDao;
import com.stt.entity.Scuser;
import com.stt.service.ScuserService;

@Service("scuserServiceImpl")
public class ScuserServiceImpl implements ScuserService {

	@Resource
	private ScuserDao scuserDao;

	@Override
	public Scuser findById(int id) {
		return scuserDao.selectByPrimaryKey(id);
	}

	@Override
	public PageInfo<Scuser> queryByPage(String name, Integer pageNo, Integer pageSize) {
		pageNo = pageNo == null?1:pageNo;
	    pageSize = pageSize == null?20:pageSize;
	    PageHelper.startPage(pageNo, pageSize);
	    List<Scuser> list = scuserDao.selectUserByName(name);
	    //用PageInfo对结果进行包装
	    PageInfo<Scuser> page = new PageInfo<Scuser>(list);
	    return page;
	}
}
