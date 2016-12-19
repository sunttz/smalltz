package com.stt.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;

import com.stt.entity.Scuser;
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
        System.out.println("name:" + name);
        if(StringUtils.isEmpty(name)){
            return null;
        }
        PageInfo<Scuser> page = scuserService.queryByPage(name,pageNo,pageSize);
        return page;
	}
}
