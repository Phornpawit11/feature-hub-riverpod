"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.TodosModule = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const todos_controller_1 = require("./todos.controller");
const todos_service_1 = require("./todos.service");
const todo_schema_1 = require("./todo.schema");
let TodosModule = class TodosModule {
};
exports.TodosModule = TodosModule;
exports.TodosModule = TodosModule = __decorate([
    (0, common_1.Module)({
        imports: [
            mongoose_1.MongooseModule.forFeature([{ name: todo_schema_1.Todo.name, schema: todo_schema_1.TodoSchema }]),
        ],
        controllers: [todos_controller_1.TodosController],
        providers: [todos_service_1.TodosService],
    })
], TodosModule);
//# sourceMappingURL=todos.module.js.map