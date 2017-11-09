-- 用户数据缓存

chapterdata = {
    chapters = {}
}

--重置用户数据
function chapterdata:resetAllData()
    chapterdata.chapters = {}
end

-- 获取残章数量
function chapterdata:getChapterCount(chapterId)
    if not chapterdata.chapters then
        return 0
    end
    local bookId = string.gsub(string.sub(chapterId, 0, 14), "chapter", "book")
    if not chapterdata.chapters[bookId] or not chapterdata.chapters[bookId][chapterId] then
        return 0
    end
    return chapterdata.chapters[bookId][chapterId]
end

function chapterdata:addChapters(chapterId, count)
    if not chapterdata.chapters then
        chapterdata.chapters = {}
    end
    local bookId = string.gsub(string.sub(chapterId, 0, 14), "chapter", "book")
    if not chapterdata.chapters[bookId] then
    	chapterdata.chapters[bookId] = {times = 1}
    end
    if not chapterdata.chapters[bookId].times then
        chapterdata.chapters[bookId].times = 1
    end
    if chapterdata.chapters[bookId][chapterId] then
    	chapterdata.chapters[bookId][chapterId] = chapterdata.chapters[bookId][chapterId] + count
    else
    	chapterdata.chapters[bookId][chapterId] = count
    end
end

function chapterdata:removeChapters(chapterId, count)
    local bookId = string.gsub(string.sub(chapterId, 0, 14), "chapter", "book")
    chapterdata.chapters[bookId][chapterId] = math.max(chapterdata.chapters[bookId][chapterId] - count, 0)
    if chapterdata.chapters[bookId][chapterId] == 0 then
    	chapterdata.chapters[bookId][chapterId] = nil
    end
end

-- 减少残章剩余合成次数
function chapterdata:reduceCombineTime(bookId)
	if not chapterdata.chapters[bookId] then
		return
	end
    local kind = 0
    for k,v in pairs(chapterdata.chapters[bookId]) do
        if k == "times" then
        else
            if v and v > 0 then
                kind = kind + 1
            end
        end 
    end
    if kind > 0 then
        return
    end
	chapterdata.chapters[bookId].times = chapterdata.chapters[bookId].times - 1
	if chapterdata.chapters[bookId].times <= 0 then
		chapterdata.chapters[bookId] = nil
	end
end


function chapterdata:getAllChapters()
	local array = {}
	for bookId,chapters in pairs(chapterdata.chapters) do
		local dic = {["bookId"] = bookId, ["chapters"] = chapters}
		table.insert(array, dic)
	end
	return array
end

function chapterdata:skillCanCombine(bookId)
	local conf = skilldata:getSkillConfig(bookId)
    local chapterNum = conf.chapternum
	local chapterPre = string.gsub(bookId, "book", "chapter")
	local flag = true
    for i=1,chapterNum do
        local chapterId = string.format("%s_%02d", chapterPre, i)
        if not chapterdata.chapters[bookId][chapterId] or chapterdata.chapters[bookId][chapterId] < 1 then
            flag = false
            break
        end
    end
    return flag
end

-- 获得残页种类
function chapterdata:getChapterPro(bookId)
	local conf = skilldata:getSkillConfig(bookId)
    local chapterNum = conf.chapternum
	local chapterPre = string.gsub(bookId, "book", "chapter")
	local count = 0
	for i=1,chapterNum do
        local chapterId = string.format("%s_%02d", chapterPre, i)
        if chapterdata.chapters[bookId][chapterId] and chapterdata.chapters[bookId][chapterId] > 0 then
            count = count + 1
        end
    end
    return count
end

