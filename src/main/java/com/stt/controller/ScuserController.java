package com.stt.controller;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.stt.entity.Scuser;
import com.stt.service.ScuserService;


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
	/*@RequestMapping(value = "/userList")
	@ResponseBody
	public Object getUserList(HttpServletRequest request, Model model){
		SystemContext.setPagesize(JSONTools.getInt(jobj, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jobj, "page"));
		PageView pageView = new PageView(JSONTools.getInt(jobj, "rows"), JSONTools.getInt(jobj, "page"));
		return pageView;
	}*/
}
