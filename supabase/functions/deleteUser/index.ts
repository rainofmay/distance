import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'

serve(async (req) => {
  const supabaseUrl = Deno.env.get('SUPABASE_URL')!
  const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  const supabase = createClient(supabaseUrl, supabaseKey)

  // POST 요청의 body에서 userId를 추출
  const { userId } = await req.json()
  
  try {
    // 먼저 auth 시스템에서 사용자 삭제
    const { error: authError } = await supabase.auth.admin.deleteUser(userId)
    if (authError) throw authError

    // 그 다음 user 테이블에서 데이터 삭제
    const { error: dbError } = await supabase
      .from('user')
      .delete()
      .eq('id', userId)
    if (dbError) throw dbError

    return new Response(
      JSON.stringify({ message: "User deleted successfully" }),
      { headers: { "Content-Type": "application/json" } },
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    )
  }
})