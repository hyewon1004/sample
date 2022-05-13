package com.globalin.Controller;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.globalin.domain.Ticket;
import com.google.gson.Gson;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({ "file:src/main/webapp/WEB-INF/spring/root-context.xml",
      "file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml" })
@WebAppConfiguration
public class SampleControllerTest {
   @Autowired
   private WebApplicationContext ctx;

   // 테스트 할 때는 가짜 MVC 패턴을 만들어 주는 MOCK MVC
   private MockMvc mockMvc;

   // 테스트 시작 전에 항상 실행될 메소드
   @Before
   public void setup() {
      this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
   }

   @Test
   public void test() throws Exception {
      Ticket ticket = new Ticket();
      ticket.setGrade("aaa");
      ticket.setTno(123);
      ticket.setOwner("admin");

      // { } json 방식으로 바꿔줄 필요가 있음.
      // GSON 을 사용해서 json 방식으로 바꿔줌
      String jsonStr = new Gson().toJson(ticket);
      System.out.println(jsonStr);

      mockMvc.perform(post("/sample/ticket").contentType(MediaType.APPLICATION_JSON).content(jsonStr))
            .andExpect(status().is(200));
   }
}