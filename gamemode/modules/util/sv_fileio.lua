
Fusion.file = Fusion.file or {}

function Fusion.file:Write(filename, data)
	file.Write(filename, data)
end

function Fusion.file:Read(filePath)
  return file.Read(filepath, "DATA") or false
end

function Fusion.file:IsValid(filepath)
	return file.Exists(filepath, "DATA")
end

// Deletes a file in the data folder with a file path.
function Fusion.file:Delete(filepath)
	if not self:IsValid(filepath) then return end
	file.Delete(filepath)
end

// Quick delete a file that is not in a directory
function Fusion.file:QuickDelete(file)
	if not self:IsValid(file) then return end

	file.Delete(file)
end