package egovframework.vo;

public class ProgramVO {
    private int programPk; // 프로그램 PK
    private String name;   // 프로그램 이름

    // Getters and Setters
    public int getProgramPk() {
        return programPk;
    }

    public void setProgramPk(int programPk) {
        this.programPk = programPk;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
