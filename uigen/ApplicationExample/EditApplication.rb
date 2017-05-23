require_relative '../lib/ui-generator'
require_relative '../lib/Utils'

class CreateApplicationClaim < UiGenBase
    attr_accessor :createButton, :name, :type, :valueType, :claims
    include Utils

    def init
        self.createButton = ElementByCss("#btnAddClaim")
        self.name =  self.generateUniqueString(15)
        self.type = "string"
        self.valueType =  self.generateUniqueString(8)
        self.claims = self.claimsList
    end

    def claimsList
        return ElementsByCss("#collectionClaims > md-card")
    end

    def setName(contentArea)
        ElementByChildCss(contentArea, ".Name").to_subtype.set(self.name)
    end

    def setType(contentArea)
        ElementByChildCss(contentArea, ".Type").to_subtype.set(self.type)
    end

    def setValueType(contentArea)
        ElementByChildCss(contentArea, ".ValueType").to_subtype.set(self.valueType)
    end

    def action
        self.createButton.click
        Watir::Wait.until { ElementsByCss(".collection-body.visible").length > 0 }
        contentArea = ElementByCss(".collection-body.visible")
        self.setName(contentArea)
        self.setType(contentArea)
        self.setValueType(contentArea)
        ElementByChildCss(contentArea, "#btnSaveClaim").click
    end

    def after_state
        return self.claimsList().length > self.claims.length
    end

    implements IAction
    implements IAfterState
end

class EditApplicationClaim < UiGenBase
    #attr_accessor :application_list
    include Utils

    def init        
    end

    def action
        
    end

    def before_state
        return true
    end

    implements IAction
    implements IBeforeState
end