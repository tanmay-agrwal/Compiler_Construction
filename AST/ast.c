#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ast.h"

ASTNode* createNumberNode(int value) {
    printf("Creating NUMBER node: %d\n", value);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_NUMBER;
    node->data.value = value;
    node->base = 10;  // Default base is 10
    return node;
}


ASTNode* createOperatorNode(NodeType type, ASTNode* left, ASTNode* right) {
    printf("Creating OPERATOR node: %d\n", type);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = type;
    node->data.children.left = left;
    node->data.children.right = right;
    return node;
}

ASTNode* createVarDeclNode(const char* name, ASTNode* type) {
    printf("Creating VAR_DECL node: %s\n", name);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_VAR_DECL;
    node->data.var_decl.var_name = strdup(name);
    node->data.var_decl.var_type = type;
    return node;
}

ASTNode* createIDNode(const char* name) {
    printf("Creating ID node: %s\n", name);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_ID;
    node->data.str_value = strdup(name);
    return node;
}

ASTNode* createTypeNode(const char* type) {
    printf("Creating TYPE node: %s\n", type);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_TYPE;
    node->data.str_value = strdup(type);
    return node;
}

ASTNode* createStringNode(const char* str) {
    printf("Creating STRING node: %s\n", str);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_STRING;
    node->data.str_value = strdup(str);
    return node;
}

ASTNode* createStringConcatNode(const char* str, ASTNode* next) {
    printf("Creating STRING_CONCAT node: %s\n", str);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_STRING_CONCAT;
    node->data.str_value = strdup(str);
    node->data.children.right = next;
    return node;
}

ASTNode* createCharNode(char c) {
    printf("Creating CHAR node: %c\n", c);
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_CHAR;
    node->data.char_value = c;
    return node;
}

ASTNode* createAssignNode(ASTNode* target, NodeType type, ASTNode* expr) {
    printf("Creating ASSIGN node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = type;
    node->data.assign.target = target;
    node->data.assign.expr = expr;
    return node;
}

ASTNode* createIfNode(ASTNode* cond, ASTNode* then_block, ASTNode* else_block) {
    printf("Creating IF node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_IF;
    node->data.control.cond = cond;
    node->data.control.then_block = then_block;
    node->data.control.else_block = else_block;
    return node;
}

ASTNode* createForNode(ASTNode* init, ASTNode* cond, ASTNode* update, ASTNode* amount, ASTNode* body) {
    printf("Creating FOR node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_FOR;
    node->data.for_control.init = init;
    node->data.for_control.cond = cond;
    node->data.for_control.upd = update;
    node->data.for_control.amount = amount;
    node->data.for_control.stmt = body;
    return node;
}

ASTNode* createWhileNode(ASTNode* cond, ASTNode* body) {
    printf("Creating WHILE node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_WHILE;
    node->data.control.cond = cond;
    node->data.control.then_block = body;
    node->data.control.else_block = NULL;
    return node;
}

ASTNode* createPrintNode(ASTNode* format_str, ASTNode* args) {
    printf("Creating PRINT node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_PRINT;
    node->data.io.format_str = format_str;
    node->data.io.args = args;
    return node;
}

ASTNode* createScanNode(ASTNode* format, ASTNode* vars) {
    printf("Creating SCAN node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_SCAN;
    node->data.io.format_str = format;
    node->data.io.args = vars;
    return node;
}

ASTNode* createFormatNode(ASTNode* node) {
    printf("Creating FORMAT node\n");
    ASTNode* format_node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!format_node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    format_node->type = NODE_FORMAT;
    format_node->data.children.left = node;
    return format_node;
}

ASTNode* createProgramNode(ASTNode* declarations, ASTNode* statements) {
    printf("Creating PROGRAM node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_PROGRAM;
    node->data.children.left = declarations;
    node->data.children.right = statements;
    return node;
}

ASTNode* createStatementListNode(ASTNode* stmt, ASTNode* next) {
    if (!stmt) return next;
    printf("Creating STATEMENT_LIST node\n");
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    if (!node) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    node->type = NODE_STATEMENT_LIST;
    node->data.children.left = stmt;
    node->data.children.right = next;
    return node;
}

void printAST(ASTNode* node) {
    if (node == NULL) return;
    
    switch (node->type) {
        case NODE_NUMBER:
    if (node->base == 10) {
        printf("(%d %d)", node->data.value, node->base);
    } else if (node->base == 2) {
        // Convert to binary representation for display
        char binary[33];
        int val = node->data.value;
        int i = 0;
        while (val > 0) {
            binary[i++] = (val % 2) + '0';
            val /= 2;
        }
        binary[i] = '\0';
        
        // Reverse the string
        for (int j = 0; j < i/2; j++) {
            char temp = binary[j];
            binary[j] = binary[i-j-1];
            binary[i-j-1] = temp;
        }
        
        printf("(%s %d)", binary, node->base);
    } else if (node->base == 8) {
        // Convert to octal representation
        printf("(%o %d)", node->data.value, node->base);
    } else {
        printf("(%d %d)", node->data.value, node->base);
    }
    break;

            
        case NODE_ID:
            printf("%s", node->data.str_value);
            break;
            
        case NODE_STRING:
            printf("\"%s\"", node->data.str_value);
            break;
            
        case NODE_CHAR:
            printf("'%c'", node->data.char_value);
            break;
            
        case NODE_TYPE:
            printf("%s", node->data.str_value);
            break;
            
        case NODE_VAR_DECL:
            printf("(%s ", node->data.var_decl.var_name);
            printAST(node->data.var_decl.var_type);
            printf(")");
            break;
            
        case NODE_ASSIGN:
            printf("(:= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;
        
        case NODE_ADD_ASSIGN:
            printf("(+= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;
        
        case NODE_MUL_ASSIGN:
            printf("(*= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;

        case NODE_SUB_ASSIGN:
            printf("(-= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;
            
        case NODE_DIV_ASSIGN:
            printf("(/= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;
        
        case NODE_MOD_ASSIGN:
            printf("(%= ");
            printAST(node->data.assign.target);
            printf(" ");
            printAST(node->data.assign.expr);
            printf(")");
            break;
        
        case NODE_PROGRAM:
            printf("{\n");
            printAST(node->data.children.left);
            printf("\n");
            printAST(node->data.children.right);
            printf("\n}");
            break;
            
        case NODE_STATEMENT_LIST:
            printAST(node->data.children.left);
            if (node->data.children.right) {
                printf("\n");
                printAST(node->data.children.right);
            }
            break;
            
        case NODE_ADD:
            printf("(+ ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_SUB:
            printf("(- ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_MUL:
            printf("(* ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_DIV:
            printf("(/ ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_MOD:
            printf("(%% ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_EQ:
            printf("(= ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_NEQ:
            printf("(<> ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_GT:
            printf("(> ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_LT:
            printf("(< ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_GTE:
            printf("(>= ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_LTE:
            printf("(<= ");
            printAST(node->data.children.left);
            printf(" ");
            printAST(node->data.children.right);
            printf(")");
            break;
            
        case NODE_IF:
            printf("(if ");
            printAST(node->data.control.cond);
            printf("\n  ");
            printAST(node->data.control.then_block);
            if (node->data.control.else_block) {
                printf("\n  ");
                printAST(node->data.control.else_block);
            }
            printf(")");
            break;
            
        case NODE_WHILE:
            printf("(while\n");
            printAST(node->data.control.cond);
            printf("\n");
            printAST(node->data.control.then_block);
            printf(")");
            break;
            
        case NODE_FOR:
            printf("(for\n");
            printAST(node->data.for_control.init);
            printf("\n");
            printAST(node->data.for_control.cond);
            printf("\n(");
            printAST(node->data.for_control.upd);
            printf(" ");
            printAST(node->data.for_control.amount);
            printf(")\n");
            printAST(node->data.for_control.stmt);
            printf(")");
            break;
            
        case NODE_PRINT:
            printf("(print ");
            if (node->data.io.format_str) {
                printAST(node->data.io.format_str);
            }
            if (node->data.io.args) {
                printf(" ");
                printAST(node->data.io.args);
            }
            printf(")");
            break;
            
        case NODE_SCAN:
            printf("(scan ");
            if (node->data.io.format_str) {
                printAST(node->data.io.format_str);
            }
            if (node->data.io.args) {
                printf(" ");
                printAST(node->data.io.args);
            }
            printf(")");
            break;
            
        case NODE_FORMAT:
            printf("@");
            if (node->data.children.left) {
                printAST(node->data.children.left);
            }
            break;
            
        case NODE_STRING_CONCAT:
            printf("%s", node->data.str_value);
            if (node->data.children.right) {
                printAST(node->data.children.right);
            }
            break;
            
        default:
            printf("Unknown node type: %d", node->type);
            break;
    }
}

void freeAST(ASTNode* node) {
    if (!node) return;
    
    switch (node->type) {
        case NODE_ID:
        case NODE_STRING:
        case NODE_TYPE:
        case NODE_STRING_CONCAT:
            free(node->data.str_value);
            break;
            
        case NODE_VAR_DECL:
            free(node->data.var_decl.var_name);
            freeAST(node->data.var_decl.var_type);
            break;
            
        case NODE_ASSIGN:
        case NODE_ADD_ASSIGN:
        case NODE_SUB_ASSIGN:
        case NODE_MUL_ASSIGN:
        case NODE_DIV_ASSIGN:
        case NODE_MOD_ASSIGN:
            freeAST(node->data.assign.target);
            freeAST(node->data.assign.expr);
            break;
            
        case NODE_IF:
        case NODE_WHILE:
            freeAST(node->data.control.cond);
            freeAST(node->data.control.then_block);
            if (node->data.control.else_block)
                freeAST(node->data.control.else_block);
            break;
            
        case NODE_FOR:
            freeAST(node->data.control.cond);
            freeAST(node->data.control.then_block);
            freeAST(node->data.control.else_block);
            freeAST(node->data.control.update);
            break;
            
        case NODE_PRINT:
        case NODE_SCAN:
            freeAST(node->data.io.format_str);
            freeAST(node->data.io.args);
            break;
            
        case NODE_FORMAT:
        case NODE_ADD:
        case NODE_SUB:
        case NODE_MUL:
        case NODE_DIV:
        case NODE_MOD:
        case NODE_EQ:
        case NODE_NEQ:
        case NODE_GT:
        case NODE_LT:
        case NODE_GTE:
        case NODE_LTE:
        case NODE_STATEMENT_LIST:
        case NODE_PROGRAM:
            freeAST(node->data.children.left);
            freeAST(node->data.children.right);
            break;
            
        default:
            break;
    }
    
    free(node);
}
