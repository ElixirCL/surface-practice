const TodoMain = {
    mounted(){
      console.log("TODO Main mounted");

      this.handleEvent("update:todos", ({todos}) => {
        console.log("Update TODOS");
        localStorage.setItem("todos", JSON.stringify(todos));
      });

      const todos = localStorage.getItem("todos");
      if (!todos) {
        console.log("No previous TODOS found");
        return;
      }
      console.log("Found TODOS");
      console.log(todos);
      this.pushEvent("on:local:storage:mount", todos);
    }
};

export default TodoMain;
