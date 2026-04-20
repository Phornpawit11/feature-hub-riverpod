import { Model } from 'mongoose';
import { Todo, TodoDocument } from './todo.schema';
import { CreateTodoDto } from './dto/create-todo.dto';
import { UpdateTodoDto } from './dto/update-todo.dto';
export declare class TodosService {
    private readonly todoModel;
    constructor(todoModel: Model<TodoDocument>);
    findAll(): Promise<Todo[]>;
    findOne(id: string): Promise<Todo>;
    create(createTodoDto: CreateTodoDto): Promise<Todo>;
    update(id: string, updateTodoDto: UpdateTodoDto): Promise<Todo>;
    remove(id: string): Promise<{
        deleted: boolean;
    }>;
}
