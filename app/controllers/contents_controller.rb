class ContentsController < ApplicationController
  before_action :set_question
  before_action :set_genres
  
  def index
    #@quiz = Quiz.all
    if !session[:quiz_id]
      #ランダムでクイズキーを発行する。固有のキーになる。(問題終了後 破棄する)
      session[:quiz_id] = rand(100) + 1
    end
  end
  
  def answer
    @quiz_id = session[:quiz_id]
    @user_answer = params[:answer]
    @quiz_id = params[:quiz_id]
    @quiz_key = session[:quiz_id]
    @quiz = Quiz.find_by(id: @quiz_id)
    #結果テーブル作成
    @result =  Result.new(quiz_key: @quiz_key,
                          quiz_id: @quiz_id,  
                          user_answer: @user_answer)
    @result.save
    if @quiz.answer1 == @answer
      flash[:notice] = "正解です"
    else
      flash[:notice] = "不正解です"
    end
    @quiz_comment = @quiz.quiz_comment
  end
  
  def kekka
  end
  
  def create
     @quiz = Quiz.new
     @genre = Genre.all
  end
  
  def created
    @quiz = Quiz.new(question_params)
  
    if params[:content_picture]
      @quiz.content_picture = "#{@quiz.id}.contentjpg"
      image = params[:content_picture]
      File.binwrite("public/content_images/#{@quiz.content_picture}", image.read)
    end
    if @quiz.save
      flash[:notice] = "問題を投稿しました"
      redirect_to("/")
    else
      render("contents/create")
    end
  end
  
  def set_question
    #IDを無作為に抽出
    @id = Quiz.pluck(:id).sample
    @result = Result.all
    @count = 1
    #問題ID振り分け 重複していたらcountを引いて 重複していないかつカウントが問題数と同じならbreak
    #@result.each do |result|
     # if result.quiz_id == @id
      #  @id = Quiz.pluck(:id).sample
      #  @count -= 1
    #    next
    #  elsif @count == @result.count
     #   break
     # end
    #  @count += 1
    #end
    #@quiz = Quiz.all.order("RANDOM()").limit(1)
    @quiz = Quiz.find_by(id: @id)
    @quiz_Array = [@quiz.answer1,@quiz.answer2,@quiz.answer3,@quiz.answer4]
  end
  
  def set_genres
    @genre = Genre.all
    @genres = Array.new
    @i = 1 
    @genre.each do |genre|
      @genres.push(genre.name) 
    end
  end
  
  private
    def question_params
      params.require(:quiz).permit(:content, :content_picture, :answer1,:answer2,:answer3,:answer4,
                                   :genre_id,:quiz_comment,:quiz_addId)
    end
    
end