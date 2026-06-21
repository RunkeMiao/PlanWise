package top.xiaocaohub;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("top.xiaocaohub.mapper")
public class PlanwiseBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(PlanwiseBackendApplication.class, args);
    }
}
