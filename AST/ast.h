#ifndef AST_H
#define AST_H

typedef enum {
    // Core types
    NODE_NUMBER,
    NODE_ADD,
    NODE_SUB,
    NODE_MUL,
    NODE_DIV,
    NODE_MOD,
    
    // Variables and declarations
    NODE_VAR_DECL,
    NODE_ID,
    NODE_STRING,
    NODE_CHAR,
    NODE_TYPE,
    
    // Assignment variants
    NODE_ASSIGN,
    NODE_ADD_ASSIGN,
    NODE_SUB_ASSIGN,
    NODE_MUL_ASSIGN,
    NODE_DIV_ASSIGN,
    NODE_MOD_ASSIGN,
    
    // Control flow
    NODE_IF,
    NODE_FOR,
    NODE_WHILE,
    
    // I/O operations
    NODE_PRINT,
    NODE_SCAN,
    NODE_FORMAT,
    NODE_STRING_CONCAT,
    
    // Relational operators
    NODE_EQ,
    NODE_NEQ,
    NODE_GT,
    NODE_LT,
    NODE_GTE,
    NODE_LTE,
    
    // Program structure
    NODE_PROGRAM,
    NODE_STATEMENT_LIST,
    NODE_BINARY
} NodeType;

typedef struct ASTNode {
    NodeType type;
    int base;  // Added for number base (2, 8, 10)
    union {
        // Primitive values
        int value;
        char* str_value;
        char char_value;
        
        // Binary operations
        struct {
            struct ASTNode* left;
            struct ASTNode* right;
        } children;
        
        // Variable declaration
        struct {
            char* var_name;
            struct ASTNode* var_type;
        } var_decl;
        
        // Assignment
        struct {
            struct ASTNode* target;
            struct ASTNode* expr;
        } assign;
        
        // Control structures
        struct {
            struct ASTNode* cond;
            struct ASTNode* then_block;
            struct ASTNode* else_block;
            struct ASTNode* update;
        } control;

        //for structures
        struct {
            struct ASTNode* init;
            struct ASTNode* cond;
            struct ASTNode* upd;
            struct ASTNode* amount;
            struct ASTNode* stmt;
        } for_control;
        
        // I/O operations
        struct {
            struct ASTNode* format_str;
            struct ASTNode* args;
        } io;
    } data;
} ASTNode;

// Core functions
ASTNode* createNumberNode(int value);
ASTNode* createOperatorNode(NodeType type, ASTNode* left, ASTNode* right);
void printAST(ASTNode* node);
void freeAST(ASTNode* node);

// Declaration and variables
ASTNode* createVarDeclNode(const char* name, ASTNode* type);
ASTNode* createIDNode(const char* name);
ASTNode* createStringNode(const char* str);
ASTNode* createCharNode(char c);
ASTNode* createTypeNode(const char* type);
ASTNode* createStringConcatNode(const char* str, ASTNode* next);

// Statements and control flow
ASTNode* createIfNode(ASTNode* cond, ASTNode* then_block, ASTNode* else_block);
ASTNode* createForNode(ASTNode* init, ASTNode* cond, ASTNode* update, ASTNode* amount, ASTNode* body);
ASTNode* createWhileNode(ASTNode* cond, ASTNode* body);

// Assignment operations
ASTNode* createAssignNode(ASTNode* target, NodeType type, ASTNode* expr);

// I/O operations
ASTNode* createPrintNode(ASTNode* format_str, ASTNode* args);
ASTNode* createScanNode(ASTNode* format, ASTNode* vars);
ASTNode* createFormatNode(ASTNode* node);

// Program structure
ASTNode* createProgramNode(ASTNode* declarations, ASTNode* statements);
ASTNode* createStatementListNode(ASTNode* stmt, ASTNode* next);

#endif // AST_H
