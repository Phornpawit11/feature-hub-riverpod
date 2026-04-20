import { TodosService } from './todos.service';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
export declare class TodosController {
    private readonly todosService;
    constructor(todosService: TodosService);
    findAll(): Promise<import("./todo.schema").Todo[]>;
    findOne(id: string): Promise<import("./todo.schema").Todo>;
    create(createTodoDto: CreateTodoDto): Promise<import("./todo.schema").Todo>;
    update(id: string, updateTodoDto: UpdateTodoDto): Promise<import("./todo.schema").Todo>;
    remove(id: string): Promise<{
        deleted: boolean;
    }>;
}
