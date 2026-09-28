local QueueOrder = {}

-- `to` is a slot in 1..#list+1 (slot k = just above entry k). Returns the new
-- position, or nil when the drop is a no-op or out of range.
function QueueOrder.move(list, from, to)
	from = math.floor(tonumber(from) or 0)
	to = math.floor(tonumber(to) or 0)
	if from < 1 or from > #list then
		return nil
	end
	to = math.min(math.max(to, 1), #list + 1)
	if to == from or to == from + 1 then
		return nil
	end
	local insert_at = from < to and to - 1 or to
	table.insert(list, insert_at, table.remove(list, from))
	return insert_at
end

-- New playing index: it follows the track, not the slot.
function QueueOrder.follow(index, from, insert_at)
	local cur = tonumber(index) or 0
	if cur == from then
		return insert_at
	elseif from < insert_at and cur > from and cur <= insert_at then
		return cur - 1
	elseif from > insert_at and cur >= insert_at and cur < from then
		return cur + 1
	end
	return cur
end

-- Removes entry `at`. Returns the entry, the new playing index and whether the
-- playing entry was the one removed (the index then points at its successor).
function QueueOrder.remove(list, at, index)
	at = math.floor(tonumber(at) or 0)
	if at < 1 or at > #list then
		return nil
	end
	index = tonumber(index) or 0
	local entry = table.remove(list, at)
	return entry, at < index and index - 1 or index, at == index
end

return QueueOrder
