visited = set()

def DFS(node, visited):
    if node in visited:
        return
    
    visited.add(node)

    for next_node in node.children():
        if not next_node in visited:
            DFS(next_node, visited)