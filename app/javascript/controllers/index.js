// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import AuthorizeController from "./authorize_controller"
application.register("authorize", AuthorizeController)

import AnswersController from "./answer_controllers/answers_controller"
application.register("answers", AnswersController)