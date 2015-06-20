##
# daily_intakes_controller.rb
#
# university:  University of Applied Sciences Salzburg
# studie:      MultiMediaTechnology
# usage:	    Multimediaprojekt 2a (MMP2a)
# author:      - Thomas Mayrhofer (thomas@mayrhofer.at)
#              - Franziska Oberhauser

class DailyIntakesController < ApplicationController
    before_filter :require_login
    before_action :set_daily_intake, only: [:show, :edit, :update, :destroy]

    # GET /daily_intakes
    # GET /daily_intakes.json
    def index
        @daily_intakes = DailyIntake.all
    end

    # GET /daily_intakes/1
    # GET /daily_intakes/1.json
    def show
    end

    # GET /daily_intakes/new
    def new
        @daily_intake = DailyIntake.new
    end

    # GET /daily_intakes/1/edit
    def edit
    end

    # POST /daily_intakes
    # POST /daily_intakes.json
    def create
        @daily_intake = DailyIntake.new(daily_intake_params)

        respond_to do |format|
            if @daily_intake.save
                format.html { redirect_to @daily_intake, notice: 'Daily intake was successfully created.' }
                format.json { render action: 'show', status: :created, location: @daily_intake }
            else
                format.html { render action: 'new' }
                format.json { render json: @daily_intake.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /daily_intakes/1
    # PATCH/PUT /daily_intakes/1.json
    def update
        respond_to do |format|
            if @daily_intake.update(daily_intake_params)
                format.html { redirect_to @daily_intake, notice: 'Daily intake was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: 'edit' }
                format.json { render json: @daily_intake.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /daily_intakes/1
    # DELETE /daily_intakes/1.json
    def destroy
        @daily_intake.destroy
        respond_to do |format|
            format.html { redirect_to daily_intakes_url }
            format.json { head :no_content }
        end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_daily_intake
        @daily_intake = DailyIntake.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def daily_intake_params
        params.require(:daily_intake).permit(:key, :value, :unit, :category)
    end

    private :set_daily_intake, :daily_intake_params
end
