package com.spring.user;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.user.dao.CodeMngDAO;
import com.spring.user.dao.ItemListDAO;
import com.spring.user.vo.CodeMngVO;
import com.spring.user.vo.ItemListVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		return "home";
	}
	
	@RequestMapping(value = "/itemList.do", method = RequestMethod.GET)
	public String itemList(Locale locale, Model model) {	
		CodeMngDAO codeMngDAO = sqlSession.getMapper(CodeMngDAO.class);
		ArrayList<CodeMngVO> itemCategoryList = codeMngDAO.getItemCategory();
		model.addAttribute("itemCategoryList", itemCategoryList);
		return "itemList";
	}
	
	@ResponseBody
	@RequestMapping(value = "/get_1st_categoryList.do", method = RequestMethod.GET)
	public ArrayList<CodeMngVO> get_1st_categoryList(Model model, HttpServletRequest request, HttpServletResponse response) {
		CodeMngDAO codeMngDAO = sqlSession.getMapper(CodeMngDAO.class);
		ArrayList<CodeMngVO> get_1st_categoryList = codeMngDAO.get_1st_categoryList(request.getParameter("upcd"));
		return get_1st_categoryList;
	}
	
	@ResponseBody
	@RequestMapping(value = "/get_Category_Result.do", method = RequestMethod.GET)
	public ArrayList<ItemListVO> get_Category_Result(Model model, HttpServletRequest request, HttpServletResponse response) {
		ItemListDAO itemListDAO = sqlSession.getMapper(ItemListDAO.class);
		ArrayList<ItemListVO> get_Category_Result = itemListDAO.get_Category_Result(request.getParameter("itemclscd"));
		return get_Category_Result;
	}
	
}
