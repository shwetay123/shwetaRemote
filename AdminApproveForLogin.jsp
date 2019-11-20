<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.List"%>
<%@page import="com.lti.model.User"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<h3><a href='AddUser.jsp'>Add User</a> | <a href='Home.jsp'>Home</a></h3>
	<table>
		<tr>
			<th>Full Name</th>
			<th>Role</th>
			<th>Aadhar Card</th>
			<th>Pan Card</th>
			<th>Certificate</th>
			<th>Approve ?</th>
			<th>Reject ?</th>
		</tr>
		<c:forEach var="user" items="${ requestScope.UserList }">
			<c:url var="deleteUrl" value="deleteUser.do">
				<c:param name="userId" value="${ user.user_id }"></c:param>
			</c:url>
			
			
			<c:url var="approveUrl" value="approveUser.do">
				<c:param name="userId" value="${ user.user_id }"></c:param>
				<c:param name="role" value="${user.role}"></c:param>		
			</c:url>
			
			
			<tr>
				<td> <c:out value="${ user.firstname  + user.lastname +user.lastname }"></c:out> </td>
				<td> <c:out value="${ user.role }"></c:out> </td>
				<td> <c:out value="${ user.aadhar_card }"></c:out> </td>
				<td> <c:out value="${ user.pan_card }"></c:out> </td>
				<td> <c:out value="${ user.certificate }"></c:out> </td>


				<td><a href='<c:out value="${ approveUrl}" />'><input type="button" value="Approve"/></a></td>
				<td><a href='<c:out value="${ deleteUrl }"></c:out>'><input type="button" value="Reject"/></a></td>


			</tr>
		</c:forEach>
	</table>
</body>
</html>



Controller Page

@RequestMapping(path="viewRegistrationPendingRequest.do", method=RequestMethod.GET)
	public String viewRegistrationPendingRequest(Model model){
		List<User> user = service.readRegistrationPendingRequest();
		model.addAttribute("UserList", user);
		return "AdminApproveForLogin.jsp";
	}


Service Layer
	
	public List<User> service.readRegistrationPendingRequest() {
		List<User> list = dao.service.findRegistrationPendingRequest();
		return list;
	}

Dao Layer


	public List<User> findRegistrationPendingRequest() {
		String jpql = "Select u from User where u.status ='not_approved' ";
		TypedQuery<User> tquery = entityManager.createQuery(jpql, User.class);
		List<User> list = tquery.getResultList();
		if(list.size() !=0){
		return list;
		}else{
		return null;
		}
		
	}




Controller Page

@RequestMapping(path="deleteUser.do")
	public String deleteUser(@PathParam("userId") int userId){
		boolean result = service.removeUser(userId);
		if(result){
			return "redirect:welcomeAdmin";
		}
		return "Error";
	}


Service Layer

@Transactional
	public boolean removeEmployee(int userId) {
		int result = dao.deleteUser(userId);
		if(result == 1){
			return true;
		}else{
			return false;
		}
	}


Dao Layer

public int deleteUser(userId) {

		String jpql ="delete u from User where u.userId:=userId";
		Query query= entityManager.createNamedQuery("jpql");
		query.setParameter("userId", userId);
		int result = query.executeUpdate();
		return result;
	}







Controller Page

@RequestMapping(path="approveUser.do", method=RequestMethod.GET)
	public String approveUser(){
		return "UpdateEmployee";
	}


Service Layer


@Transactional
	public User approve(Employee employee) {
		Employee employee2 = getDao().updateEmployee(employee);
		return employee2;
	}