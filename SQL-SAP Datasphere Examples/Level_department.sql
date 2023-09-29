/*
COALESCE(Parent11NodeID,Parent10NodeID,Parent9NodeID,Parent8NodeID,Parent7NodeID,Parent6NodeID,Parent5NodeID,Parent4NodeID,Parent3NodeID,Parent2NodeID,Parent1NodeID,ChildNodeID)
*/

CASE
WHEN Parent10NodeID = dep_L1
THEN Parent9NodeID
WHEN Parent9NodeID = dep_L1 AND Parent10NodeID IS NULL
THEN Parent8NodeID
WHEN Parent8NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent7NodeID
WHEN Parent7NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent6NodeID
WHEN Parent6NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent5NodeID
WHEN Parent5NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent4NodeID
WHEN Parent4NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent3NodeID
WHEN Parent3NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN Parent2NodeID
WHEN Parent2NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL AND Parent3NodeID IS NULL
THEN Parent1NodeID
WHEN ChildNodeID = dep_L1
THEN NULL
END

CASE
WHEN Parent10NodeID = dep_L1
THEN Parent9NodeID_name
WHEN Parent9NodeID = dep_L1 AND Parent10NodeID IS NULL
THEN Parent8NodeID_name
WHEN Parent8NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent7NodeID_name
WHEN Parent7NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent6NodeID_name
WHEN Parent6NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent5NodeID_name
WHEN Parent5NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent4NodeID_name
WHEN Parent4NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent3NodeID_name
WHEN Parent3NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN Parent2NodeID_name
WHEN Parent2NodeID = dep_L1 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL AND Parent3NodeID IS NULL
THEN Parent1NodeID_name
WHEN ChildNodeID = dep_L1
THEN NULL
END


----------------

CASE
WHEN Parent10NodeID = dep_L1 AND Parent9NodeID = dep_L2
THEN Parent8NodeID
WHEN Parent9NodeID = dep_L1 AND Parent8NodeID = dep_L2 AND Parent10NodeID IS NULL
THEN Parent7NodeID
WHEN Parent8NodeID = dep_L1 AND Parent7NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent6NodeID
WHEN Parent7NodeID = dep_L1 AND Parent6NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent5NodeID
WHEN Parent6NodeID = dep_L1 AND Parent5NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent4NodeID
WHEN Parent5NodeID = dep_L1 AND Parent4NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent3NodeID
WHEN Parent4NodeID = dep_L1 AND Parent3NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent2NodeID
WHEN Parent3NodeID = dep_L1 AND Parent2NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN Parent1NodeID
WHEN Parent2NodeID = dep_L1 AND Parent1NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL AND Parent3NodeID IS NULL
THEN ChildNodeID
WHEN ChildNodeID = dep_L2
THEN NULL
END

CASE
WHEN Parent10NodeID = dep_L1 AND Parent9NodeID = dep_L2
THEN Parent8NodeID_name
WHEN Parent9NodeID = dep_L1 AND Parent8NodeID = dep_L2 AND Parent10NodeID IS NULL
THEN Parent7NodeID_name
WHEN Parent8NodeID = dep_L1 AND Parent7NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent6NodeID_name
WHEN Parent7NodeID = dep_L1 AND Parent6NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent5NodeID_name
WHEN Parent6NodeID = dep_L1 AND Parent5NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent4NodeID_name
WHEN Parent5NodeID = dep_L1 AND Parent4NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent3NodeID_name
WHEN Parent4NodeID = dep_L1 AND Parent3NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent2NodeID_name
WHEN Parent3NodeID = dep_L1 AND Parent2NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN Parent1NodeID_name
WHEN Parent2NodeID = dep_L1 AND Parent1NodeID = dep_L2 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL AND Parent3NodeID IS NULL
THEN ChildNodeID
WHEN ChildNodeID = dep_L2
THEN NULL
END

------------------
CASE
WHEN Parent10NodeID = dep_L1 AND Parent9NodeID = dep_L2 AND Parent8NodeID = dep_L3
THEN Parent7NodeID
WHEN Parent9NodeID = dep_L1 AND Parent8NodeID = dep_L2 AND Parent7NodeID = dep_L3 AND Parent10NodeID IS NULL
THEN Parent6NodeID
WHEN Parent8NodeID = dep_L1 AND Parent7NodeID = dep_L2 AND Parent6NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent5NodeID
WHEN Parent7NodeID = dep_L1 AND Parent6NodeID = dep_L2 AND Parent5NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent4NodeID
WHEN Parent6NodeID = dep_L1 AND Parent5NodeID = dep_L2 AND Parent4NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent3NodeID
WHEN Parent5NodeID = dep_L1 AND Parent4NodeID = dep_L2 AND Parent3NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent2NodeID
WHEN Parent4NodeID = dep_L1 AND Parent3NodeID = dep_L2 AND Parent2NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent1NodeID
WHEN Parent3NodeID = dep_L1 AND Parent2NodeID = dep_L2 AND Parent1NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN ChildNodeID
WHEN ChildNodeID = dep_L3
THEN NULL
END

CASE
WHEN Parent10NodeID = dep_L1 AND Parent9NodeID = dep_L2 AND Parent8NodeID = dep_L3
THEN Parent7NodeID_name
WHEN Parent9NodeID = dep_L1 AND Parent8NodeID = dep_L2 AND Parent7NodeID = dep_L3 AND Parent10NodeID IS NULL
THEN Parent6NodeID_name
WHEN Parent8NodeID = dep_L1 AND Parent7NodeID = dep_L2 AND Parent6NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL
THEN Parent5NodeID_name
WHEN Parent7NodeID = dep_L1 AND Parent6NodeID = dep_L2 AND Parent5NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL
THEN Parent4NodeID_name
WHEN Parent6NodeID = dep_L1 AND Parent5NodeID = dep_L2 AND Parent4NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL
THEN Parent3NodeID_name
WHEN Parent5NodeID = dep_L1 AND Parent4NodeID = dep_L2 AND Parent3NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL
THEN Parent2NodeID_name
WHEN Parent4NodeID = dep_L1 AND Parent3NodeID = dep_L2 AND Parent2NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL
THEN Parent1NodeID_name
WHEN Parent3NodeID = dep_L1 AND Parent2NodeID = dep_L2 AND Parent1NodeID = dep_L3 AND Parent10NodeID IS NULL AND Parent9NodeID IS NULL AND Parent8NodeID IS NULL AND Parent7NodeID IS NULL AND Parent6NodeID IS NULL AND Parent5NodeID IS NULL AND Parent4NodeID IS NULL
THEN ChildNodeID_name
WHEN ChildNodeID = dep_L3
THEN NULL
END
------------------