package com.stt.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import com.stt.entity.Scuser;
import com.stt.dao.QueryLogDao;
import com.stt.entity.QueryLog;
import com.stt.service.ScuserService;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * Created by Administrator on 2016/12/15.
 */
@Controller
@RequestMapping("/scuser")
public class ScuserController {
    @Resource
    private ScuserService scuserService;
    @Resource
    private QueryLogDao queryLogDao;
    
    @RequestMapping("/show")
    public String show(HttpServletRequest request, Model model){
        int id = Integer.parseInt(request.getParameter("id"));
        Scuser scuser = scuserService.findById(id);
        model.addAttribute("scuser",scuser);
        return "showUser";
    }
    
    /**
	 * 查询用户列表
	 * @return
	 */
	@RequestMapping(value = "/userList")
	@ResponseBody
	public Object getUserList(HttpServletRequest request, Model model){
        String name = request.getParameter("name");
        int pageNo = Integer.parseInt(request.getParameter("page"));
        int pageSize = Integer.parseInt(request.getParameter("rows"));
        if(StringUtils.isEmpty(name)){
            return null;
        }
        if(pageNo == 1){
        	// 记录查询日志
        	QueryLog log = new QueryLog();
        	log.setName(name);
        	try {
        		queryLogDao.insertSelective(log);
        	} catch (Exception e) {
        		e.printStackTrace();
        	}
        }
        PageInfo<Scuser> page = scuserService.queryByPage(name,pageNo,pageSize);
        return page;
	}
}
