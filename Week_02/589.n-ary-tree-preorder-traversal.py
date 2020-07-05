#
# @lc app=leetcode id=589 lang=python3
#
# [589] N-ary Tree Preorder Traversal
#

# @lc code=start
"""
# Definition for a Node.
class Node:
    def __init__(self, val=None, children=None):
        self.val = val
        self.children = children
"""

class Solution:
    def preorder(self, root: 'Node') -> List[int]:
        if not root:
            return []
        traversal = [root.val]
        for child in root.children:
            traversal.extend(self.preorder(child))
        return traversal

    def preorder1(self, root: 'Node') -> List[int]:
        if not root: return []
        stack = [root]
        out = []
        while stack:
            temp = stack.pop()
            out.append(temp.val)
            stack.extend(reversed(temp.children))
        return out

    def preorderfast(self, root: 'Node') -> List[int]:
        ret, q = [], root and [root]
        while q:
            node = q.pop()
            ret.append(node.val)
            q += [child for child in reversed(node.children) if child]
        return ret


# @lc code=end

