using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DissloveTest : MonoBehaviour
{
    public Material originalMat;
    public Material dissolveMat;
    float duration = 3.0f;
    Renderer rend;

    // Start is called before the first frame update
    void Start()
    {
        rend = this.GetComponent<Renderer>();
        StartCoroutine(DissolveSample());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private IEnumerator DissolveSample()
    {
        float timeElapsed = 0;
        while (timeElapsed < 2f)
        {
            rend.material.Lerp(originalMat, dissolveMat, timeElapsed / duration);
            timeElapsed += Time.deltaTime;
            yield return null;
        }

        while (timeElapsed > 0f)
        {
            rend.material.Lerp(originalMat, dissolveMat, timeElapsed / duration);
            timeElapsed -= Time.deltaTime;
            yield return null;
        }

        /*        while (triggerHeldTime < 3f)
                {
                    triggerHeldTime += Time.time;
                    float lerp = Time.time / duration;
                    rend.material.Lerp(originalMat, dissloveMat, lerp);
                    yield return null;
                }*/
    }
}
