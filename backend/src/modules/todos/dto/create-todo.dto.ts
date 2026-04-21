export class CreateTodoDto {
  title: string;
  description?: string;
  isDone: boolean = false;
}
