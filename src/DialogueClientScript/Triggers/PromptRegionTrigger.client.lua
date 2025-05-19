local promptRegionPart = dialogueServer.settings.promptRegion.basePart;
    if promptRegionPart then

      promptRegionPart.Touched:Connect(function(part)

        -- Make sure our player touched it and not someone else
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(part.Parent);
        if PlayerFromCharacter == player then

          self:interact(dialogueServer);

        end;

      end);

    end;