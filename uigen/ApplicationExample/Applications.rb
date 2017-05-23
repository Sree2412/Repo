require_relative '../lib/ui-generator'
require_relative '../lib/Utils'

class Applications < UiGenBase
    attr_accessor :application_list
    include Utils

    def init
        self.application_list = ElementsByCss("#select-application")
    end

    def action
        puts "ClaimsAuthApplications.Action!!"
    end

    def get_applications
        return ElementsByCss(".md-list-item")
    end

    def appExists?(name)
        self.get_applications().each do |app|
            return true if app.text.include? name
        end
        return false
    end

    def getApplication(name)
        self.get_applications().each do |app|
            return app if app.text.include? name
        end
        return nil
    end

    implements IAction
end

class ApplicationSelect < Applications
    attr_accessor :ApplicationCreate, :appRef

    def action
        if self.ApplicationCreate != nil
            self.appRef = self.getApplication(self.ApplicationCreate.appName)
        else
            apps = get_applications()
            self.appRef = apps[Random.rand(apps.length)]
        end

        if self.appRef == nil
            raise ArgumentError, "Unable to find application '#{self.ApplicationCreate.appName}' in list."
        end
        
        self.appRef.click
    end
end

class ApplicationCreate < Applications
    attr_accessor :input, :button, :appName, :appListLength

    def init
        super
        self.appName = self.generateUniqueString(15)
        self.input = ElementByCss("#new-application input")
        self.button = ElementByCss("#btnCreateApp")
    end

    def action
        self.input.to_subtype.set(self.appName)
        self.button.click
    end

    def before_state
        self.appListLength = self.get_applications().length
        return self.appExists?(self.appName) == false
    end

    def after_state
        Watir::Wait.until { self.get_applications().length != self.appListLength }

        return self.appExists? self.appName
    end

    implements IAction
    implements IBeforeState
    implements IAfterState
end